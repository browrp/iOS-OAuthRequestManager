//
//  AuthorizedApiRequest.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 10/26/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//

import Foundation
import Alamofire


/*
 *Notes: https://stackoverflow.com/questions/29131253/swift-alamofire-how-to-get-the-http-response-status-code
*/


/*
 --
 Defines the type of OAuth flow to use.  Right now just ResourceOwnerPasswordGrant will be
 supported.  The thought is when the AuthorizedApiRequest class is passed the configuation with a particular Type the AuthorizedApiRequest class will call a factory to create it's own internal Adapter & Retrier based on that particular flow.
*/
enum OAuthApiRequestManagerType:String{
    case ResourceOwnerPasswordGrant
    case ClientCredentials  //Not implemented
    case AuthorizationCode //Not Implemented yet
}



/*
 --
 Defines the OAuth flow to use, the ClientId, ClientSecret, TokenEndpoint (ROPG), AuthorizeEndpoint (for AuthorizationCode flow)
*/
struct OAuthApiRequestManagerSettings{
    //What type of OAuth flow to use
    var AuthorizedApiRequestType: OAuthApiRequestManagerType
    //Optional Client ID
    var clientId: String?
    //Optional Client Secret
    var clientSecret: String?
    //Optional Scope
    var scope: String?
    //Token endpoint
    var tokenUri: String
    var loginUri: String
    
    //var serverTrustPolicies: [String: ServerTrustPolicy] = [
    //    "localhost": .disableEvaluation,
    //    "192.168.1.136": .disableEvaluation
    //]
    var serverTrustPolicies: [String: ServerTrustPolicy]?
    
    //Authorization Code endpoint (Not Implemented)
    //var authorizeUri: String?

}







/*
 --
 Delegates that the AuthorizedApiRequest class can raise.
 
 authenticationFailure - called when the initialAuthentication via Authorize/Authenticate is called
 refreshTokenFailure - called when
*/
protocol OAuthApiRequestManagerDelegate{
    func authenticationFailure(_ sender: OAuthApiRequestManager)
    func refreshTokenFailure(_ sender: OAuthApiRequestManager)
}



class OAuthApiRequestManager: RequestAdapter,RequestRetrier  {
  
    private var _settings: OAuthApiRequestManagerSettings
    public var _credentialSet: OAuthApiRequestManagerCredentialSet

    private let _secureSessionManager: Alamofire.SessionManager
    private let loginSessionManager: Alamofire.SessionManager
    
    public var credentialsFoundOnStartup: Bool = false
    
    //public let adapt: AdaptRetry
    
//    //ToDo: Make this configurable
//    /// Set the Alamofire Server Trust Policies so that localhost's SSL isn't validatated.
//    let serverTrustPolicies: [String: ServerTrustPolicy] = [
//        "localhost": .disableEvaluation,
//        "192.168.1.136": .disableEvaluation
//    ]

 

    
    enum OAuthApiRequestResult{
        case success(Data)  // case success(AnyObject)
        case failure(OAuthApiRequestError)
    }
    
    /// The Result that is returned from an *authorize(...)* call.
    enum AuthorizeResult{
        case success(OAuthApiRequestManagerCredentialSet) //    case success(AnyObject)
        case failure(OAuthApiAuthorizeError) //Should we have our own custom Error Types here?
    }
    
    /*
    enum LoginResult{
        case success(OAuthApiRequestManagerCredentialSet)
        case failure(OAuthApiRequestError)
    }
    */

    
    //Some other public properties that we'll probalby have to wrap up later
    //var tokenUri: String
    //var loginUri: String
    
    
    
    
    // MARK: - Delegates
    
    /// Allows for notification to occur when an authentication failure occurs, this can occur when
    /// the token expires and an optional refresh isn't successful.
    var authenticationFailure: OAuthApiRequestManagerDelegate?
    
    
    // MARK: - Initializers

    
    
    //TODO: Make the initializer create a "sub-class" that will handle a Password Resource Owner Grant Type vs Client Credentials, vs PKCE(to-be-implemented)
    /**
     Initialize the OAuthApiRequestManager with settings that setup the type of endpoint. A Credential Set is created internally and only wil live the lifetime of the appliation.
     - parameter settings: An OAuthApiRequestManagerSettings object that contains the OAuth settings for the endpoint.
     */
    init(settings: OAuthApiRequestManagerSettings){
        let configuration = URLSessionConfiguration.default
        
        
        //self._secureSessionManager = Alamofire.SessionManager(configuration:configuration)

        
        
        // Setup the Session Managers
        let loginSMConfig = URLSessionConfiguration.ephemeral

        if let stp = settings.serverTrustPolicies{
            _settings = settings
            self._secureSessionManager = Alamofire.SessionManager(configuration:configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: stp ))
            loginSessionManager = Alamofire.SessionManager(configuration: loginSMConfig, serverTrustPolicyManager: ServerTrustPolicyManager(policies: stp ))


        }else{
            self._secureSessionManager = Alamofire.SessionManager(configuration:configuration)
            loginSessionManager = Alamofire.SessionManager(configuration: loginSMConfig)
        }
     
        _settings = settings
        _credentialSet = OAuthApiRequestManagerCredentialSet()
        
        //ToDo: Future versions can determine what type of Authentication Type and then generate the proper Retrier and Adapter
        //      and set it.  For now it's just Password Grant
        _secureSessionManager.retrier = self
        _secureSessionManager.adapter = self
    }
    
    
    //Notes: If no credentialset is passed in then we will just use the credential set for the lifetime of the app, when it shuts down then the cred-set goes away.
    
    /**
     Initialize the OAuthApiRequestManager with settings that setup the type of endpoint. Keychain data will be queried upon initialization upon startup and if not found will be persisted.
     - parameter settings: An OAuthApiRequestManagerSettings object that contains the OAuth settings for the endpoint.
     - parameter credentialSet: An OAuthApiRequestManagerCredentialSet object that holds the oAuth credentials such as token, refreshtoken, expiry.  NOTE Should add username?, password?, etc to this to hold all information
     */
    convenience init(settings: OAuthApiRequestManagerSettings, credentialSet: OAuthApiRequestManagerCredentialSet)
    {
        self.init(settings: settings)
        
        //Attempt to laod an Credential Set if nothing found then initialize one with the current credential set.
        //otherwise load it
        
        _credentialSet = credentialSet
        let credsFound = _credentialSet.retrieveCredentialsFromKeychain()
        if(credsFound){
            //Credentials found
            credentialsFoundOnStartup = true
        }
        else{
            //No Credentials found
            credentialsFoundOnStartup = false
        }
    }
    

    
    ///ClientId & ClientSecret
    ///Make an intial call to the authorization endpoint to get a token and optional refresh token
    func authorize()
    {
        //Made a call to the authorize enpoint passing the username/password, or clientid and client secret to get a token with optional refresh token.
        //If this call fails then no token will be retrieved and the existing token that is stored in the
        //should this be done with a username/login or is this a refresh call?
        
        
    }
    
    
    //Note: This authorize call should be a protocol that is optionally implemented based on the Grant Type.
    
    /**
     Call the Authorize Endpoint for a ResourceOwnerPasswordGrant endpoint.
     - parameter username: The username
     - parameter password: The user's passowrd
     - parameter saveCreds: Save the credentials in the keychain for future use.
     */
    ///Resource Owner Password Grant
    ///Make an initial call to the authorization endpoint to get a token and optional refresh token.
    func authorize(username: String,
                   password: String,
                   saveForFuture saveCreds: Bool=false,
                   completionBlock: @escaping (AuthorizeResult) -> Void)
    {
        // eventually check for && _settings.AuthorizedApiRequestType != OAuthApiRequestManagerType.AuthorizationCode
        if(_settings.AuthorizedApiRequestType == OAuthApiRequestManagerType.ResourceOwnerPasswordGrant)
        {
            /// Call into the login function which will get some credentials if sueccessful.
            self.login(username, password: password) { (authResult) in
                switch authResult{
                    case .success(var credentialSet):
                        credentialSet.username=username
                        credentialSet.password=password
                        if(saveCreds){
                            credentialSet.saveData()
                        }
                        completionBlock(AuthorizeResult.success(credentialSet))
                        return;
                    
                    case .failure(let oAuthApiAuthorizeError):
                        completionBlock(AuthorizeResult.failure(oAuthApiAuthorizeError))
                        return;
                }
            }//end:login-completion-closure
        
        }
        else{
            //You can't call login on other flows.
            completionBlock(AuthorizeResult.failure(OAuthApiAuthorizeError.IncompatibleFlowType))
            return;
        }
    }
    
    
    
    //If this whole class is going to be static then we may as well have some information that sets up the Alamofire Request Adapter & Request Retrier
    
    /**
     Make a Secure OAuth request using the Request Manager which will pass the oAuth Bearer token for the call.
     - parameter urlRequest: The urlRequest object containing the information about the URL, Type and any parameters.
     */
    //func SecureRequest(urlRequest:URLRequestConvertable, completionHandler:@escaping (Result<T>)->Void)
    //we will return the err or success on this and let the data service https://medium.com/@AladinWay/write-a-networking-layer-in-swift-4-using-alamofire-5-and-codable-part-2-perform-request-and-b5c7ee2e012d
    func SecureRequest(urlRequest:URLRequestConvertible, completionHandler:@escaping (OAuthApiRequestResult)->Void){
        
        //Set the Authorization Header Here
        print("OAuthApiRequestManager::SecureRequest:Start")
        print("OAuthApiRequestManager::SecureRequest:Making request now.")
        let request = _secureSessionManager.request(urlRequest)
        
        //Make the Authorized Network Call
        //_secureSessionManager.request(urlRequest)
        debugPrint("Secure Request\n");
            debugPrint(request)
            request.validate(statusCode: 200..<400)
            .responseData{ (defaultDataResponse) in
                //debugPrint(defaultDataResponse.request)
                debugPrint(defaultDataResponse.response)
                switch defaultDataResponse.result{
                case .success(let value):       //ROBERT THIS IS THE ONE THAT I FOUND!!!
                    print("OAuthApiRequestManager: SecureRequest callback - Success.")

                    do{
                        
                        if let returnData = String(data: value, encoding: .utf8) {
                            print("We have data!")
                            print(returnData)
                        } else {
                            print("No data returned or could not be extracted.")
                        }
                        
                        completionHandler(OAuthApiRequestResult.success(value))
                        
                        //let localDealsResult = try JSONDecoder().decode(LocalDealsResponse, from: value as Data)
                        ////let localDealsResult = try JSONDecoder().decode( [LocalDealsResponse].self, from: defaultDataResponse.data!)
                        ////let localDealsResult = try JSONDecoder().decode([LocalDealsResponse].self, from: defaultDataResponse.data)
                    }
                    catch let error as NSError {
                        print(error.localizedDescription)
                        completionHandler(OAuthApiRequestResult.failure(OAuthApiRequestError.RawEror(error)))
                        
                    }
                    
                case .failure(let error):
                    print("OAuthApiRequestManager: SecureRequest callback - Failure.")

                    completionHandler(OAuthApiRequestResult.failure(OAuthApiRequestError.RawEror(error)))
                    return
                }
        }
        print("OAuthApiRequestManager::SecureRequest:End")

    }
    
    
    func StandardRequest(urlRequest:URLRequestConvertible, completionHandler:@escaping (OAuthApiRequestResult)->Void)
    {
        //Call an unsecured Alamofire instance.
        print("STANDARD REQUEST!!!")
        
        
        //Alamofire.upload(
    }
    
    
    
    //MARK: Login & Logout Functions
    //Perhaps this should be part of the UserData or better yet have the userService do all of this crap and call into the Unauthenticated
    func login(_ username: String, password: String, completionBlock: @escaping ((AuthorizeResult) -> Void)){

        var parameters: Parameters = [
            "username":"\(username)",
            "password":"\(password)",
            "grant_type":"password"
        ]
        
        //Optionally append the clientID and clientSecret if provided.
        if(_settings.clientId != nil)
        {
            //let clientInfo: Parameters = ["client_id" : _settings.clientId]
            parameters.updateValue(_settings.clientId!, forKey: "client_id")
            //parameters.append(clientInfo)
            
            if(_settings.clientSecret != nil)
            {
                //let clientSecret: Parameters = ["client_secret" : _settings.clientSecret]
                parameters.updateValue(_settings.clientSecret!, forKey: "client_secret")
            }
        }
        
        //Must Be: application/x-www-form-urlencoded post type https://github.com/IdentityServer/IdentityServer4/issues/1658
        let request = loginSessionManager.request( _settings.tokenUri,
                                         method: .post,
                                         parameters: parameters)//,encoding: JSONEncoding.default
        request.validate().responseJSON{
            response in
            switch response.result {
            case .success(let value):
                print("Login Callback Success")
                print("HTTP Status Code: \(response.response?.statusCode)")

                if let val =  value as? [String: AnyObject]{
                    //Will the app crash if these values don't come back
                    self._credentialSet.authToken = val["access_token"] as! String
                    self._credentialSet.expiresInValue = val["expires_in"] as! Double
                    self._credentialSet.refreshToken = val["refresh_token"] as? String
                    self._credentialSet.creationTime = val["created_at"] as? Double
                
                    completionBlock(AuthorizeResult.success(self._credentialSet))
                }
            case .failure(let error):
                // Write the error out to the console.
                print("Login Callback Failure")
                print("Status Code: \(response.response?.statusCode)")
                if let data = response.data {
                    let jsonString = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(jsonString)")
                    
                    
                    if let errPayload = try? (JSONSerialization.jsonObject(with: data, options: [])) {
                        //as? [String : Any])
                        if let errNest = errPayload as? [String : Any]{
                            if let errDesc = errNest["error_description"] as? String{
                                print("Server response: \(errDesc)")
                                //http://swiftdeveloperblog.com/code-examples/compare-two-strings-equal/
                                if(errDesc.caseInsensitiveCompare("invalid_username_or_password") == ComparisonResult.orderedSame){
                                    completionBlock(AuthorizeResult.failure(OAuthApiAuthorizeError.InvalidUsernamePassword("invalid_usename_or_password")))
                                    return
                                }
                                else{
                                    completionBlock(AuthorizeResult.failure(OAuthApiAuthorizeError.Other(errDesc)))
                                    return
                                }
                            }//end if errDesc could be extracted
                        }
                    }
                    completionBlock(AuthorizeResult.failure(.Other(jsonString ?? "Server response not decodable")))
                    return
                }//end:if let data=response.data
                completionBlock(AuthorizeResult.failure(OAuthApiAuthorizeError.Unknown(error)))
                return
            }//end switch response.result
            
        }//end:request-callback-closure
        
    
    }//end switch
    
    /****************************************/
    
    
    
    
    //private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    private typealias RefreshCompletion = (_ succeeded: Bool, _ refreshData: [String: AnyObject]?) -> Void
    
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    private let lock = NSLock()
    
    //private var clientID: String
    //private var baseURLString: String
    //private var accessToken: String
    //private var refreshToken: String
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    //public init(clientID: String, baseURLString: String, accessToken: String, refreshToken: String) {
    //    self.clientID = clientID
    //    self.baseURLString = baseURLString
    //    self.accessToken = accessToken
    //    self.refreshToken = refreshToken
    //}

    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        print("OAuthApiRequestManager: Adapt beginning")

        if urlRequest.url != nil{
            print("urlRequest is THERE!");
            var urlRequest = urlRequest
            print("Show me the token: \(self._credentialSet.authToken)");
            urlRequest.setValue("Bearer " + (self._credentialSet.authToken! ?? "" ), forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        else{
            print("OAuthApiRequestManager: Adapt urlRequest.url is nil.")
        }
        print("OAuthApiRequestManager: Adapt end. Returning...")
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, jsonData in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    /*
                     if let accessToken = accessToken, let refreshToken = refreshToken {
                     //strongSelf.accessToken = accessToken
                     //strongSelf.refreshToken = refreshToken
                     let tokenReturnData: [String: AnyObject] = [
                     "access_token": accessToken,
                     "refresh_token": refreshToken,
                     "expires_in": expiresIn ?? "bearer",
                     "token_type": tokenType ?? 0
                     ]
                     UserData.oAuthTokenInstance.populate(value: tokenReturnData)
                     }
                     */
                    
                    //UserData.oAuthTokenInstance.populate(value: jsonData!)
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    //Robert make this try refresh tokens and if not then try username and password and if not then we just need to bail out with a fail code.
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        if(self._credentialSet.hasRefreshToken()){
            //Attempt to use refresh token
            //"access_token": UserData.oAuthTokenInstance.access_token ?? "",     //We don't need the access token although should we turn it on?
            let parameters: [String: Any] = [
                "refresh_token": self._credentialSet.refreshToken ?? "",
                "grant_type": "refresh_token"
            ]
            
            sessionManager.request(_settings.tokenUri, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { [weak self] response in
                    guard let strongSelf = self else { return }
                    
                    //WARNING WARNING WARNING WARNING
                    //IM ASSUMING THIS IS WORKING BUT NOT CHECKING FOR THE RESPONSE.
                    //THE CRASH IS HAPPENING IN "extractTokenData"
                    
                    if let json = response.result.value as? [String: AnyObject] {
                        
                        //we have something back from the tokenUri lets see if we can extract it
                        if(strongSelf.extractTokenData(refreshData: json) )
                        {
                            completion(true, [:])
                            return;
                        }
                        else{
                            //Attempt to login using credentials passing this completion block down to the next level.
                            strongSelf.refreshUsingLogin(completion: completion)
                            //return
                        }
                    
                    } else {
                        completion(false, nil)
                    }
                    strongSelf.isRefreshing = false
            }//end sessionManager.request
            
        }
        else if(self._credentialSet.hasUsername()){
            //Attempt login using username password
            self.refreshUsingLogin(completion: completion)
        }
        
        completion(false, [:]);
        return;
    }
    
    
    private func refreshUsingLogin(completion: @escaping RefreshCompletion){
        //If we get here then we couldn't extract the data,
        //either it's because it was malformed or it wasnt' successful
        if(self._credentialSet.hasUsername()){
            self.login(self._credentialSet.username!, password: self._credentialSet.password!
                , completionBlock: { (oAuthApiRequestManager_AuthorizeResult) in
                    switch(oAuthApiRequestManager_AuthorizeResult)
                    {
                    case .success(let credentialSet):
                        completion(true, [:])
                        return;
                    case .failure(let oAuthApiRequestError):
                        completion(false, [:])  //we've completely run out
                        return;
                    }
            });
        }
        else{
            completion(false, [:])
            return;
        }
        
    }
    
    /// Attempt to extract token data and store it in the classes Credential Manager
    /// - Returns - True if successful (Token data minimum)
    ///             False if unsuccessful
    func extractTokenData(refreshData: [String: AnyObject]?) -> Bool{
        if let json = refreshData as? [String: String]{
            _credentialSet.authToken = json["access_token"]
            _credentialSet.refreshToken = json["refresh_token"] ?? ""
            let expireStr = json["expires_in"] ?? ""
            if let expireVal = Double(expireStr){
                _credentialSet.expiresInValue = expireVal
            }
            
            return true
        }
        return false
    }
    
    // MARK: - Private - Internal Credential Set Information
    
}












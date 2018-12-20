//
//  UserService.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 10/22/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//

import Foundation
import Alamofire

//should we init this and make it a singleton?
//or should we pass in the oauthapirequestmanaer instance?
//what's the best way to use that?
class UserService
{
    // MARK: - Singleton Creation Routines
    private static var sharedUserService: UserService = {
        let userService = UserService()
        // Configuration if any
        // ...
        return userService
    }()
    
    //Only allow the creation of this object via the shared instance.
    private init(){
        
    }
    
    class func shared() -> UserService{
        return sharedUserService
    }
    // End Singleton Creation Routines
    
    
    // Allows the class to be tied to a specific OAuthApiRequestManager
    // Usage: UserService.shared().oAuthApiRequestManager = CustomOAuthApiRequesteManagerInstance
    var oAuthApiRequestManager: OAuthApiRequestManager!
    
    
    
    /*
    func GetProfile(completionHandler:@escaping (NetworkResult)->Void){
        
    }
    */ 
    
    func getProfile(completion:@escaping (Result<String>)->Void) {

        /*
        oAuthApiRequestManager.SecureRequest(urlRequest: UserEndpoint.getProfile(id: 23)) { (result) in
            switch result{
            case .success(let returnData):
                var u = User()
                completion(Result.success(u))
            case .failure(let returnErr):
                completion(Result.failure(returnErr))
            }
        }
        */
        
        print("UserService::getProfile:Start.")

        print("UserService::getProfile:Making request now.")
        
        oAuthApiRequestManager.SecureRequest(urlRequest: UserService.UserEndpoint.getProfile) { (daResult) in
            print("UserService::getProfile: SecureRequest Callback")
            switch daResult
            {
            case .success(let data):
                //                if let json = try? (JSONSerialization.jsonObject(with: data, options: [])){
                if let json =  String(data: data, encoding: String.Encoding.utf8){
                    print(json)
                    completion(Result<String>.success(json))
                }
                else{
                    
                    completion(Result<String>.success("JSON Decoding didn't work"))
                    print("JSON Decoding didn't work")
                }
            
            case .failure(let err):
                completion(Result<String>.failure(err))
                print("Failed with error: \(err)")
            }
        }
        print("UserService::getProfile:End")
    }
    
    func updateProfile(completion:@escaping (Result<User>)->Void){
        
    }
}


extension UserService{
    
    enum UserEndpoint: APIConfiguration{
        
        //case getProfile(id: Int)
        case getProfile
        case updateProfile(firstName: String, lastName: String)
        case uploadAvatar
        
        // MARK: - HTTPMethod
        var method: HTTPMethod{
            switch  self {
            case .getProfile:
                return .get
                
            case .updateProfile:
                return .put
                
            case .uploadAvatar:
                return .post
            }
        }
        
        
        // MARK: - Path
        var path: String{
            switch self{
            //case .getProfile(let id):
            //    return "/profile/\(id)"
            case .getProfile:
                return "/identity/Claims"
            case .updateProfile:
                return "/profile/update"
            case .uploadAvatar:
                return "/profile/uploadAvatar"
            }
            
        }
        
        
        // MARK - Parameters
        var parameters: Parameters?{
            switch self {
            //case .getProfile(let id):
            //    return ["id":id]
            case .getProfile:
                return nil
            case .updateProfile(let firstName, let lastName):
                return ["firstname":firstName, "lastname":lastName]
                
            case .uploadAvatar:
                return [:]
            }
            
        }
        
        
        func asURLRequest() throws -> URLRequest {
            let url = try K.ProductionServer.baseURL.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            
            // HTTP Method
            urlRequest.httpMethod = method.rawValue
            
            // Common Headers
            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
            // Parameters
            if let parameters = parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
            
            return urlRequest
        }
        
    }//end UserEndpoint
}


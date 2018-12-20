//
//  OAuthApiRequestManagerCredentialSet.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 10/26/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//

import Foundation
import Locksmith


//Look into this Follow this: http://www.raywenderlich.com/92667/securing-ios-data-keychain-touch-id-1password
struct OAuthApiRequestManagerCredentialSet  {
    var authToken:      String?
    var refreshToken:   String?
    var expiresInValue:    TimeInterval?
    var creationTime:   TimeInterval?
    
    var username:       String?
    var password:       String?
    
    
    private var _account: String
    private var _service: String
    
    // MARK: - Keychain Protocol Requirements
    var account: String {
        return _account
    }
    var service: String {
        return _service
    }
    
    
   // MARK: - Initialization
    
    /**
     Initialize the OAuthApiRequestManagerCredentialset with default settings
     */
    init(){
        _account = ""
        _service = ""
        
    }
    
    
    init(forAccount account:String, andService service:String){
        _account = account
        _service = service
    }
    
    
    /**
     Initialize the OAuthApiRequestManagerCredentialset with keychain settings and specify if it should load from keychain upon initialization.
     - parameter account: account name for keychain
     - parameter service: service name for keychain
     - parameter loadFromKeychainOnInit: should the data be loaded from keychain upon initializtion (default false)
     */
    init(forAccount account:String, andService service:String, loadFromKeychainOnInit load:Bool? = false){
        _account = account
        _service = service
        //if load == true then attempt a load from the keychain
        if(load == true)
        {
            var result : Bool = retrieveCredentialsFromKeychain()
            //Do something with that result
        }
    }
    
    

    
    // MARK: - Public - Methods
    // Checks if the token that is stored in the keychain is expired
    //Note modified to remove the KeychainService calls and values stored locally.
    func isTokenExpired() -> Bool {
        
        var isTokenExpired: Bool = true
        
        
        if let expiresTimeInterval = expiresInValue {
            if let creationTimeInterval:TimeInterval = creationTime{
                // need to refresh the token
                if (Date().timeIntervalSince1970 < creationTimeInterval + expiresTimeInterval) {
                    isTokenExpired = false
                }
            }
        }
        
        return isTokenExpired
    }//end isAccessTokenExpired()
    
    func hasToken()->Bool{
        if(!(authToken==nil)){
            return true
        }else{
            return false
        }
    }
    
    func hasRefreshToken()->Bool{
        if(!(refreshToken==nil)){
            return true;
        }
        return false;
    }
    
    
    func hasUsername()->Bool{
        if((username==nil) || (username?.count ?? 0)==0){
            return false;
        }
        return true;
    }
    
    mutating func retrieveCredentialsFromKeychain() -> Bool
    {
        //Get all items from keychain
        if let data = Locksmith.loadDataForUserAccount(userAccount: account, inService: service)
        {
            
            
            //Why can't I use GUARD here?
            if let atkn = data["authToken"] as! String?{
                authToken = atkn
            }else{
                authToken = nil
            }
            if let rtkn = data["refreshToken"] as! String?{
                refreshToken = rtkn
            }
            else{
                refreshToken=nil
            }
            if let eiv = data["expiresIn"] as! TimeInterval?{
                expiresInValue = eiv
            }
            else{
                expiresInValue=nil
            }
            if let ct = data["creationTime"] as! TimeInterval?{
                creationTime = ct
            }
            else{
                creationTime = nil
            }
            
            if let un = data["username"] as! String?{
                username = un
            }
            else {
                username = nil
            }
            
            if let pw = data["password"] as! String?{
                password = pw
            }
            else{
                password = nil            }
            return true;
        }
        else
        {
            authToken = nil
            refreshToken = nil
            expiresInValue = nil
            creationTime = nil
            return false
        }
    }//end::
    
    
    
    mutating func saveData()->Bool{
        
        var localDict = [String: AnyObject]()
        if let authToken=authToken{
            localDict["authToken"] = authToken as AnyObject?
        }
        else{
            localDict["authToken"] = nil
        }
        
        if let rToken=refreshToken{
            localDict["refreshToken"] = rToken as AnyObject?
        }
        else{
            localDict["refreshToken"] = nil
        }
        if let expVal=expiresInValue{
            localDict["expiresIn"] = expVal as AnyObject?
        }else{
            localDict["expiresIn"]=nil
        }
        if let creationTime = creationTime{
            localDict["creationTime"] = creationTime as AnyObject?
        }else{
            localDict["creationTime"] = nil
        }
        
        if let username = username{
            localDict["username"] = username as AnyObject?
        }
        
        if let password = password{
            localDict["password"] = password as AnyObject?
        }
        
        do{
            //try Locksmith.updateData(data: localDict, forUserAccount: "buzzardfly.com", inService: "oauth")
            try Locksmith.updateData(data: localDict, forUserAccount: account, inService: service)
        }
        catch{
            print("OAuthBearerCredentialSet.saveData :: Locksmith.updateData - failed")
            return false;
        }
        return true;
    }//end::saveData
    
}//end::struct OAuthBearerCredentialSet

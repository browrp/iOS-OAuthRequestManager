//
//  AppDelegate.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 7/27/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var authReqManager: OAuthApiRequestManager!
    var authManagerSettings: OAuthApiRequestManagerSettings!
    var authManagerCredentials: OAuthApiRequestManagerCredentialSet!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "localhost": .disableEvaluation,
            "192.168.1.136": .disableEvaluation,
            "macbook-pro-860.local" : .disableEvaluation,
            "macbook-pro-870.local:5000": .disableEvaluation,
             "macbook-pro-870.local:5001": .disableEvaluation
        ]

        //https://macbook-pro-870.local:5000
        
        /*
        authManagerSettings = OAuthApiRequestManagerSettings(AuthorizedApiRequestType:      OAuthApiRequestManagerType.ResourceOwnerPasswordGrant,
                                                             clientId: "ro.client", clientSecret: "", scope: "api1", tokenUri: "https://192.168.1.136:5001/connect/token", loginUri: "https://192.168.1.136:5001/connect/token", serverTrustPolicies: serverTrustPolicies)
        */
        
        /*
        authManagerSettings = OAuthApiRequestManagerSettings(AuthorizedApiRequestType:      OAuthApiRequestManagerType.ResourceOwnerPasswordGrant,
        clientId: "ro.client", clientSecret: "", scope: "api1", tokenUri: "https://macbook-pro-870.local:5001/connect/token", loginUri: "https://macbook-pro-870.local:5001/connect/token", serverTrustPolicies: serverTrustPolicies)
        */
        

        
        /*
        authManagerSettings = OAuthApiRequestManagerSettings(AuthorizedApiRequestType:      OAuthApiRequestManagerType.ResourceOwnerPasswordGrant,
                                                             clientId: "ro.client", clientSecret: "", scope: "api1", tokenUri: "https://localhost:5001/connect/token", loginUri: "https://localhost:5001/connect/token", serverTrustPolicies: serverTrustPolicies)
        */

        /*
        authManagerSettings = OAuthApiRequestManagerSettings(AuthorizedApiRequestType:      OAuthApiRequestManagerType.ResourceOwnerPasswordGrant,
                                                             clientId: "ro.client", clientSecret: "", scope: "api1", tokenUri: "http://robert-mbp.msbb.uc.edu:5001/connect/token", loginUri: "https://robert-mbp.msbb.uc.edu:5001/connect/token", serverTrustPolicies: serverTrustPolicies)
        */
        
        
        
        
        /*
        authManagerSettings = OAuthApiRequestManagerSettings(AuthorizedApiRequestType:      OAuthApiRequestManagerType.ResourceOwnerPasswordGrant,
                                                             clientId: "ro.client", clientSecret: "", scope: "api1", tokenUri: "http://localhost:5001/connect/token", loginUri: "http://localhost:5001/connect/token", serverTrustPolicies: serverTrustPolicies)

        */
        
        authManagerSettings = OAuthApiRequestManagerSettings(AuthorizedApiRequestType:      OAuthApiRequestManagerType.ResourceOwnerPasswordGrant,
                                                             clientId: "ro.client", clientSecret: "", scope: "api1", tokenUri: "http://robert-mbp.local:5001/connect/token", loginUri: "http://robert-mbp.local:5001/connect/token", serverTrustPolicies: serverTrustPolicies)
        
        
        authManagerCredentials = OAuthApiRequestManagerCredentialSet(forAccount: "Default", andService: "UCIdentity")
        authReqManager = OAuthApiRequestManager(settings: authManagerSettings, credentialSet: authManagerCredentials)
        

        
        if(authReqManager.credentialsFoundOnStartup){
            print("Credentials found for service \(authManagerCredentials.service) and service \(authManagerCredentials.service)")
        }
        
        
        UserService.shared().oAuthApiRequestManager = authReqManager
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


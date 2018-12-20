//
//  Constants.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 10/23/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//


import Foundation

struct K {
    struct ProductionServer {
        //static let baseURL = "https://localhost:3000/api/v1"
        //static let baseURL = "http://localhost:5000"
       // static let baseURL = "http://192.168.1.136:5000"
        //static let baseURL = "https://macbook-pro-870.local:5000"
        
        
        //static let baseURL = "http://robert-mbp.msbb.uc.edu:50034"
        
        
        //working 
        
        //static let baseURL = "http://localhost:50034"
        
        static let baseURL = "http://robert-mbp.local:50034"
        


    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

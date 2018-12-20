//
//  ApiConfiguration.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 10/22/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

//
//  OAuthApiRequestManagerEnums.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 10/26/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//

import Foundation


/// Represents the type of errors that the OAuthApiRequestManager can return
enum OAuthApiRequestError: Error{
    
    /// No credentials are found or have been specified in an OAuthApiRequestManagerCredentialSet
    case MissingCredentials
    
    /// All possible credentials have been tried and failed.  This includes existing token, refresh token, and username and password.
    case AllCredentialsFailed
    
    /// An error occurred but is not handled by this error type, but we've given you a String that describes the error
    case Other(String)
    
    /// An error occurred but is not handled by this error type, an inner error is passed for your... pleasure...  LoL
    case RawEror(Error)
    
    case NoDataReturned
    
    /// Authorization Failed due to an invalid username or password.  String provides additional information from authitentication endpoint if available.
    case InvalidUsernamePassword(String)
    
}



///  Represents errors that can occur during an Authorize Operation (authorize, login, etc...)
enum OAuthApiAuthorizeError: Error {
    
    /// The flow type set in the configuration does not work with the authorize method called.
    case IncompatibleFlowType
    
    case MissingCredentials
    
    
    case InvalidUsernamePassword(String)
    
    /// An error occurred but is not currently handled by the case statements, the server response string is returned.
    case Other(String)
    
    /// An error occurred and no data could be extracted from the server response, the underlying Error is returned.
    case Unknown(Error)
    
    /// Example of a type of error that could be raised
    //case InvalidSMSCode(String)
    
}

//
//  APIClient.swift
//  VirtualTouristApp
//
//  Created by Khalid Aqeeli on 23/08/2020.
//  Copyright © 2020 Khalid Aqeeli. All rights reserved.
//

import Foundation


class APIClient {
    
    
    enum Endpoint {
        static let base:String = ""
        static let loginPath:String = ""
        
        case login

        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoint.base + Endpoint.loginPath
            }
        }
        var url:URL {
            return URL(string: stringValue)!
        }
    }

    
}

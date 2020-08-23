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
        static let base:String = "https://onthemap-api.udacity.com/v1/"
        static let downloadLimit:String = "StudentLocation?order=-updatedAt&limit=100"
        static let loginPath:String = "session"
        static let studentLocation:String = "StudentLocation"
        
        case login
        case getStudentLocation
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoint.base + Endpoint.loginPath
            case .getStudentLocation:
                return Endpoint.base + Endpoint.downloadLimit
            case .postStudentLocation:
                return Endpoint.base + Endpoint.studentLocation
            }
        }
        var url:URL {
            return URL(string: stringValue)!
        }
    }

    
}

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
        static let base:String = "https://api.flickr.com"
        static let path = "/services/rest"
        
        case getImages

        var stringValue: String {
            switch self {
            case .getImages:
                return Endpoint.base + Endpoint.path
            }
        }
        var url:URL {
            return URL(string: stringValue)!
        }
    }
}

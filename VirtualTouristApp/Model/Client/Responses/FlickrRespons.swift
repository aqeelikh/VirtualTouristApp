//
//  FlickrRespons.swift
//  VirtualTouristApp
//
//  Created by Khalid Aqeeli on 23/08/2020.
//  Copyright © 2020 Khalid Aqeeli. All rights reserved.
//

import Foundation

extension APIClient {
    
    // MARK: - JSONFlickrAPI
    struct JSONFlickrAPI: Codable {
        let photos: Photos
        let stat: String
    }

    // MARK: - Photos
    struct Photos: Codable {
        let page, pages, perpage: Int
        let total: String
        let photo: [Photo]
    }

    // MARK: - Photo
    struct Photo: Codable {
        let id, owner, secret, server: String
        let farm: Int
        let title: String
        let ispublic, isfriend, isfamily: Int
    }

    
    
    
    
}

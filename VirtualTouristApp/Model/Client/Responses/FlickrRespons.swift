//
//  FlickrRespons.swift
//  VirtualTouristApp
//
//  Created by Khalid Aqeeli on 23/08/2020.
//  Copyright © 2020 Khalid Aqeeli. All rights reserved.
//

import Foundation


    
    // MARK: - JSONFlickrAPI
struct FlickrRespons: Codable {
    let photos: FlickerPhotos
    let stat: String
}

    // MARK: - Photos
struct FlickerPhotos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [FlickerPhoto]
}

    // MARK: - Photo
struct FlickerPhoto: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

    
    
    


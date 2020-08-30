//
//  APIClient.swift
//  VirtualTouristApp
//
//  Created by Khalid Aqeeli on 23/08/2020.
//  Copyright © 2020 Khalid Aqeeli. All rights reserved.
//

import Foundation


class APIClient {
    
    static let key:String = "d600bfad28e89aab6956f2c36c42db75"
    
    // Constract the URL for the Flicker API end point
    enum Endpoint {
        static let base:String = "https://www.flickr.com/services/rest/"
        static let urlMethod = "?method=flickr.photos.search"
        static let format = "format=json"
        static let apiKey = "api_key="
        static let lat = "lat="
        static let lon = "lon="
        static let page = "page="
    }
    
    class func getImages(latitude:Double , longtuid:Double,range:Int,completion: @escaping (FlickrRespons?, Error?) -> Void) {
        
        let randomPage = Int.random(in: 1 ... range)

        let request = URLRequest(url: self.composeURL(latitude, longtuid,randomPage))
           let session = URLSession.shared.dataTask(with: request) { data, response, error in
             if error != nil { // Handle error...
                 return
             }
             let decoder = JSONDecoder()
             do {
               let responseObject = try decoder.decode(FlickrRespons.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                   print(error.localizedDescription)
            }
        }
    }
        session.resume()
    }
    
    class func composeURL(_ latitude:Double,_ longtuid:Double, _ randomPage:Int) -> URL {
        
        let url:String = Endpoint.base + Endpoint.urlMethod + "&" + Endpoint.format + "&" + Endpoint.apiKey + key + "&" + Endpoint.lat + "\(latitude)" + "&" + Endpoint.lon + "\(longtuid)" + "&nojsoncallback=1&accuracy=11&per_page=20" + "&" + Endpoint.page + "\(randomPage)"
        print(url)
        return URL(string: url)!

    }
}
    

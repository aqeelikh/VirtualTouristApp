//
//  UIResponseViewController.swift
//  VirtualTouristApp
//
//  Created by Khalid Aqeeli on 28/08/2020.
//  Copyright © 2020 Khalid Aqeeli. All rights reserved.
//

import Foundation
import UIKit
import Reachability

extension UIViewController{
    
    

     func showAlert(message:String){
         let alertController = UIAlertController(title: "Virtual Tourist App", message: message, preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
         self.present(alertController, animated: true, completion: nil)
             }
    
    
    // MARK: Monitor Network Connectivity
    @objc func reachabilityChanged(_ note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.connection != .unavailable {
        if reachability.connection == .wifi {
        print("Reachable via WiFi")
        } else {
            print("Reachable via Cellular")
        }
        } else {
            
            self.showAlert(message: "Please check your internet connection")
        }
    }
    
}



extension UIViewController {

     static var baseBackColor = UIColor(white: 0, alpha: 0.6)
     static var baseColor = UIColor.gray
    
    func startAnActivityIndicator() -> UIActivityIndicatorView {

            let frame = UIScreen.main.bounds
            let spinner = UIActivityIndicatorView(frame: frame)
            spinner.backgroundColor = UIViewController.baseBackColor
            spinner.color = UIViewController.baseColor
            self.view.addSubview(spinner)
            self.view.bringSubviewToFront(spinner)
            spinner.center = self.view.center
            spinner.hidesWhenStopped = true
            spinner.startAnimating()
            return spinner
        }
}




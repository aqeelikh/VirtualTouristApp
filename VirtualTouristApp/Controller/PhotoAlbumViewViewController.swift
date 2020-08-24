//
//  PhotoAlbumViewViewController.swift
//  VirtualTouristApp
//
//  Created by Khalid Aqeeli on 22/08/2020.
//  Copyright © 2020 Khalid Aqeeli. All rights reserved.
//

import UIKit
import CoreData
import MapKit

private let reuseIdentifier = "FlickerCollectionViewCell"

class PhotoAlbumViewViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pin: Pin!
    var annotation: MKAnnotation!
    var dataController: DataController!

    @IBOutlet weak var flickerCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        flickerCollectionView.delegate = self
        flickerCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        setUpRegin(latitude: (annotation?.coordinate.latitude)! , longitud: (annotation?.coordinate.longitude)!)
    }

    func setUpRegin(latitude:Double,longitud:Double){
        
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitud)
        
        self.mapView.addAnnotation(annotation)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func AsynchronousDownloadImage(cellImage:UIImageView) {
        
        let url = NSURL(string: "https://farm2.staticflickr.com/1736/41994168344_4e810efb98_b.jpg")
               let downloadQueue = DispatchQueue(label: "download", attributes: [])
               
               // call dispatch async to send a closure to the downloads queue
               downloadQueue.async { () -> Void in

                   // download Data
                   let imgData = try? Data(contentsOf: url! as URL)

                   // Turn it into a UIImage
                   let image = UIImage(data: imgData!)

                   // display it
                   DispatchQueue.main.async(execute: { () -> Void in
                      return cellImage.image = image
                   })
               }
    }
    
    
    //MARK:- Collection View
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickerCollectionViewCell
        //let memeCell = self.memes[(indexPath as NSIndexPath).row]
        
        AsynchronousDownloadImage(cellImage: cell.flickerImage)
        cell.flickerImage.image = UIImage()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}



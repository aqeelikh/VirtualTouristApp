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
import Kingfisher



private let reuseIdentifier = "FlickerCollectionViewCell"

class PhotoAlbumViewViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    var pin: Pin!
    var annotation: MKAnnotation!
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<Photo>!

    var photoArray:[Photo] = []
    var response:FlickerPhotos!
    
    @IBOutlet weak var flickerCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        flickerCollectionView.delegate = self
        flickerCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        setUpRegin(latitude: (annotation?.coordinate.latitude)! , longitud: (annotation?.coordinate.longitude)!)
        fetchImagesFromDB()
    }
    
    @IBAction func collectionViewUpdateButton(_ sender: Any) {

    }
    
    //MARK:- TODO:- Refactor fetchImagesFromDB()
    func fetchImagesFromDB(){
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin = %@", pin)
        if let results = try? dataController.viewContext.fetch(fetchRequest), results.count != 0 {
               photoArray = results
           } else {
               fetchFlickerPhotos()
           }
    }
    
    func fetchFlickerPhotos(){
        APIClient.getImages(latitude: annotation.coordinate.latitude, longtuid: annotation.coordinate.longitude) { (result, error) in
            guard let result = result else {
                return
            }
            self.AsynchronousDownloadImage(response: result.photos)
            self.flickerCollectionView.reloadData()
        }
    }
    
    func setUpRegin(latitude:Double,longitud:Double){
        
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitud)
        
        self.mapView.addAnnotation(annotation)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
    }
    
    //MARK:- DownloadImages in the background
    func AsynchronousDownloadImage(response:FlickerPhotos) {
        
        let imageArray =  response.photo
        for photo in imageArray {
            let url = URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg" )
            let imageView = UIImageView()
            imageView.kf.setImage(with: url) { (result, error, cache, url) in
                if error == nil {
                    //Convert photo to type compatibile to core data model
                    let imageData = result!.pngData()!
                    self.savePhoto(imageData, url!)
                } else {
                    print(error?.localizedDescription ?? "error")
                }
            }
        }
        if self.photoArray.count == 0 {
            showAlert(message: "No Images to load change location")
        }
        print("This is the totoal value:\(self.photoArray.count)")
    }
    
    //MARK: Core Data
    
    //Save images in Photo entity
    func savePhoto(_ photo: Data,_ url: URL){
        //Create photo context for core data Photo entity
        let photoContext = Photo(context: dataController.viewContext)
        photoContext.image = photo
        photoContext.url = url
        photoContext.pin = self.pin
        //Save photo context in core data
        try? dataController.viewContext.save()
        //Add element in array
        photoArray.append(photoContext)
        //Reload collection view to display new photo
        flickerCollectionView.reloadData()
        //Stop progress animation
    }
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickerCollectionViewCell
        //let memeCell = self.memes[(indexPath as NSIndexPath).row]
        let photoCell = photoArray[indexPath.row]
        //Set photo recieved
        cell.flickerImage.kf.setImage(with: photoCell.url)
        
        cell.flickerImage.kf.setImage(with: photoCell.url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // fetchedResultsController.sections?.count ?? 1
        if self.photoArray.count == 0 {
            showAlert(message: "No Images to load change location")
        }
        print("This is the totoal value:\(self.photoArray.count)")
        return photoArray.count
    }
    
}













//    fileprivate func setupFetchedResultsController() {
//        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
//        let predicate = NSPredicate(format: "pin == %@", pin)
//        fetchRequest.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(Photo)-photo")
//        fetchedResultsController.delegate = self
//
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            fatalError("The fetch could not be performed: \(error.localizedDescription)")
//        }
//    }

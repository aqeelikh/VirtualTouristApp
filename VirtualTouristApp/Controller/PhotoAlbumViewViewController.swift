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
        
        let photos: NSFetchRequest<Photo> = Photo.fetchRequest()
        photos.predicate = NSPredicate(format: "pin = %@", pin)
        
        if let results = try? dataController.viewContext.fetch(photos) {
            if results.count != 0 {
                for photo in results {
                    dataController.viewContext.delete(photo)
                    if photo == results.last {
                        photoArray.removeAll()
                        flickerCollectionView.reloadData()
                        fetchFlickerPhotos()
                    }
                }
            }
        } else {
            showAlert(message:"Error: no photos deleted")
        }
        try? dataController.viewContext.save()
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
        
        let randomPage = Int.random(in: 1 ... 10)
        APIClient.getImages(latitude: annotation.coordinate.latitude, longtuid: annotation.coordinate.longitude, range: randomPage) { (result, error) in
            guard let result = result else {
                return
            }
            self.AsynchronousDownloadImage(response: result.photos)
            self.flickerCollectionView.reloadData()
        }
    }
    
    func setUpRegin(latitude:Double,longitud:Double){
        
        let latitude = CLLocationDegrees(latitude)
        let longitud = CLLocationDegrees(longitud)
        
        self.mapView.addAnnotation(annotation)
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitud)
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
                    self.showAlert(message: error?.localizedDescription ?? "error")
                }
            }
        }
        if imageArray.count == 0 {
                showAlert(message: "No images to load choose another location")
        }
    }
    
    //MARK: Core Data
    
    //Save images in Photo entity
    func savePhoto(_ photo: Data,_ url: URL){
        
        let photoData = Photo(context: dataController.viewContext)
        photoData.image = photo
        photoData.url = url
        photoData.pin = self.pin
        
        try? dataController.viewContext.save()
        photoArray.append(photoData)
        
        flickerCollectionView.reloadData()
    }
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickerCollectionViewCell
        let photoCell = photoArray[indexPath.row]
        
        cell.flickerImage.kf.setImage(with: photoCell.url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    //Remove collectview cell when clicking on it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = photoArray[indexPath.row]
        dataController.viewContext.delete(photo)
        
        try? dataController.viewContext.save()
        photoArray.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
    
    
}

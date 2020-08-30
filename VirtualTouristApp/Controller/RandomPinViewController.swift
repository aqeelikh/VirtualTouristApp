//
//  RandomPinViewController.swift
//  VirtualTouristApp
//
//  Created by Khalid Aqeeli on 29/08/2020.
//  Copyright © 2020 Khalid Aqeeli. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import Reachability

class RandomPinViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinRandomImage: UIImageView!
    @IBOutlet weak var LocationInfoText: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setupUI()
    }
    
    var dataController:DataController!
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    var pins:[Pin] = []
    var pin:Pin?
    var photoArray:[Photo] = []
    var locationInformation:String = ""
    var addressString:String = ""
    
    
    func setupUI(){
        
        pickARandomPin(pins: pins)
        addPinToMapView(pin: self.pin!)
        fetchImagesFromDB()
        getAddressFromLatLon(Latitude: pin!.latitude, Longitude: pin!.longitude)
        self.locationInformation = addressString
    }
    
    func pickARandomPin(pins:[Pin]){
        
//        if photoArray.isEmpty{
//            self.showAlert(message: "Cant find pin information, check your Internet connection ")
//            LocationInfoText.text =  ""
//        }
        
        let randomPinIndex = Int.random(in: 0 ... pins.count-1)
        pin = pins[randomPinIndex]
    }
    
    func addPinToMapView(pin:Pin){
        
        let locations = pin
        var annotations = [MKPointAnnotation]()
        
        // This is a version of the Double type.
        let lat = CLLocationDegrees(locations.latitude)
        let long = CLLocationDegrees(locations.longitude)

        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        // Place the annotation in an array of annotations.
        annotations.append(annotation)
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    

    
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    
    func fetchImagesFromDB(){
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin = %@", pin!)
        
        if let results = try? dataController.viewContext.fetch(fetchRequest), results.count != 0 {
            photoArray = results
            let randomPhotoArrayIndex = Int.random(in: 0 ... photoArray.count-1)
            self.pinRandomImage.image = UIImage(data: photoArray[randomPhotoArrayIndex].image!)
            self.LocationInfoText.text = self.addressString
        }else{
            pinRandomImage.image = UIImage(named: "Applogo")
            LocationInfoText.text = "No Data To Display about the current location"
            self.showAlert(message:"No image to download")
        }
    }
    

    
    func composedTextView()-> String {
        
        let composedText:String = "Counter:"
        return composedText
    }
    
    @IBAction func randomIPinPicker(_ sender: Any) {
        setupUI()
    }
    
    
    func getAddressFromLatLon(Latitude: Double,Longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Latitude
        //21.228124
        let lon: Double = Longitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                
                guard let checkPm = placemarks else {
                    return
                }
                
                let pm = placemarks! as [CLPlacemark]


                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    self.LocationInfoText.text = addressString
              }
        })

    }
}

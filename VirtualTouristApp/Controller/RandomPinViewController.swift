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

class RandomPinViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinRandomImage: UIImageView!
    @IBOutlet weak var LocationInfoText: UITextView!
    
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

    
    func setupUI(){
        pickARandomPin(pins: pins)
        addPinToMapView(pin: self.pin!)
        fetchImagesFromDB()
        getAddressFromLatLon(Latitude: pin!.latitude, Longitude: pin!.longitude)
    }
    
    func pickARandomPin(pins:[Pin]){
        let randomPinIndex = Int.random(in: 0 ... pins.count-1)
        pin = pins[randomPinIndex]
        print(pins[randomPinIndex])
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
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
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
        }else{
            pinRandomImage.image = UIImage(named: "Applogo")
            LocationInfoText.text = "No Data To Display about the current location"
            print("no image to download")
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
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
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
                    print(addressString)
              }
        })

    }
}

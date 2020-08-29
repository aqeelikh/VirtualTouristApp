//
//  TravelLocationsMapViewController.swift
//  VirtualTouristApp
//
//  Created by Khalid Aqeeli on 21/08/2020.
//  Copyright © 2020 Khalid Aqeeli. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    var dataController:DataController!
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    var pins:[Pin] = []
    var lastLocation: [String: Double] = [:]
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest){
            pins = result
            mapView.removeAnnotations(mapView.annotations)
            updateMapPins(pin: pins)
        }
        configrLongPressGestureForMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK:- Get annotation from coredata
        self.saveLastLocation()
    }
    
    @objc func handleTapping(gestureRecognion: UIGestureRecognizer) {
        
        if gestureRecognion.state == UIGestureRecognizer.State.began {
            let location = gestureRecognion.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
                        
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            self.addPin(lon: Double(coordinate.longitude) , lat: Double(coordinate.latitude))
        }
    }
    
    //MARK:- Adds Annotation to CoreData
    func addPin(lon: Double,lat:Double) {
            let pin = Pin(context: dataController.viewContext)
            pin.longitude = lon
            pin.latitude = lat
            pins.append(pin)
            try? dataController.viewContext.save()
       }

    //MARK:- Configer Long Press Gesture
    func configrLongPressGestureForMap() {
        let gestureRecognion = UILongPressGestureRecognizer(target: self, action: #selector(handleTapping))
        gestureRecognion.delegate = self
        mapView.addGestureRecognizer(gestureRecognion)
    }

    //MARK:- Update pins in MapView
    func updateMapPins(pin:[Pin]){
        let locations = pin
    
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locations {
            
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
          
            // Place the annotation in an array of annotations.
            annotations.append(annotation)
        }
    
        // When the array is complete, we add the annotations to the map.
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
        
    }
    //MARK:- Add Annotation to map view
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
    
    //MARK:- Clikc on map annotation to get location image
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = view.annotation?.coordinate {
        let vcSugue = self.storyboard?.instantiateViewController(identifier: "PAVC") as! PhotoAlbumViewViewController
            
        let latitude = Double(coordinate.latitude)
        let longitude = Double(coordinate.longitude)
            
        vcSugue.annotation = view.annotation
        vcSugue.dataController = dataController
                
       for pin in pins {
        if pin.latitude == latitude && pin.longitude == longitude {
            vcSugue.pin = pin
            }
        }
        self.show(vcSugue, sender: nil)
    }
        
    }
        
    func setUpRegin(latitude:Float,longitud:Float){
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitud)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    
    func saveLastLocation() {
        if let lastLocation =  UserDefaults.standard.object(forKey: "mapLastLocation") {
            // Cast Any to [String:Double]
            let userMapViewLastLocation = lastLocation as! [String:Double]

            // Save user zoom level
            let latitudeSpan = CLLocationDegrees(userMapViewLastLocation["regionLatitude"]!)
            let longitudeSpan = CLLocationDegrees(userMapViewLastLocation["regionLongitude"]!)
            
            
            // Save user mapView center
            let latitudeCenter = CLLocationDegrees(userMapViewLastLocation["centerLatitude"]!)
            let longitudeCenter = CLLocationDegrees(userMapViewLastLocation["centerLongitude"]!)
            
            // Configure user mapView region
            let mapViewSpan = MKCoordinateSpan(latitudeDelta: latitudeSpan, longitudeDelta: longitudeSpan)
            let mapViewCenter = CLLocationCoordinate2D(latitude: latitudeCenter, longitude: longitudeCenter)
            
            mapView.region = MKCoordinateRegion(center: mapViewCenter, span: mapViewSpan)
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        lastLocation["centerLatitude"] = Double(mapView.region.center.latitude)
        lastLocation["centerLongitude"] = Double(mapView.region.center.longitude)
        
        lastLocation["regionLatitude"] = Double(mapView.region.span.latitudeDelta)
        lastLocation["regionLongitude"] = Double(mapView.region.span.longitudeDelta)
        
        UserDefaults.standard.set(lastLocation, forKey: "mapLastLocation")
    }
    
    
    
    //MARK:- Pick a rondom Pin
    
    @IBAction func pickARandomPin(_ sender: Any) {
        
        if pins.isEmpty {
            self.showAlert(message: "No Pins Downloaded")
        }else{
             let vcSugue = self.storyboard?.instantiateViewController(identifier: "randomPin") as! RandomPinViewController
             vcSugue.dataController = self.dataController
             vcSugue.pins = self.pins
             self.show(vcSugue, sender: nil)
        }
    }
}

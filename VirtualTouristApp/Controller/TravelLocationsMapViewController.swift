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
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
//        DispatchQueue.main.async {
//               self.updateMapPins()
//        }
        
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
    }
    
    //MARK:- TODO CHANGE and refactore the code
    @objc func handleTapping(gestureRecognion: UIGestureRecognizer) {
        
        if gestureRecognion.state == UIGestureRecognizer.State.began {
            let location = gestureRecognion.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            
            print("location longitude: \(coordinate.longitude), location latitude: \(coordinate.latitude)")
            
            // Add annotation:
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
            try? dataController.viewContext.save()
       }

    //MARK:- Configer Long Press Gesture
    func configrLongPressGestureForMap() {
        let gestureRecognion = UILongPressGestureRecognizer(target: self, action: #selector(handleTapping))
        gestureRecognion.delegate = self
        mapView.addGestureRecognizer(gestureRecognion)
    }

    //MARK:- TODO add pinch and drag gestures.
    
    
    //MARK:- Update pins in MapView
    func updateMapPins(pin:[Pin]){
        // data that you can download from parse.
        let locations = pin
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
          
            // Finally we place the annotation in an array of annotations.
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
        
        let vcSugue = self.storyboard?.instantiateViewController(identifier: "PAVC") as! PhotoAlbumViewViewController
        vcSugue.annotation = view.annotation
        
        vcSugue.dataController = dataController
        self.show(vcSugue, sender: nil)
        
        print("annotation latitude :\(String(describing: view.annotation?.coordinate.latitude)) ")
        print("annotation longitude :\(String(describing: view.annotation?.coordinate.longitude)) ")
    }
    
    func setUpRegin(latitude:Float,longitud:Float){
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitud)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
}


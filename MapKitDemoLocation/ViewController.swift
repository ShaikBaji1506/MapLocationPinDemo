//
//  ViewController.swift
//  MapKitDemoLocation
//
//  Created by Shaik Baji on 27/11/19.
//  Copyright © 2019 smartitventures.com. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}


class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
    
var locationManager = CLLocationManager()
@IBOutlet weak var mapObj: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //In this demo we were going to learn how to show the current location of the user using MapView we can get the users current lat and long and we can mark the annotation to the users location with their address titles
        
        mapObj.showsUserLocation = true //intimates user to visible the current location
        
        mapAnnotations()
        
        if CLLocationManager.locationServicesEnabled() == true
        {
            
         if CLLocationManager.authorizationStatus() == .restricted ||  CLLocationManager.authorizationStatus() == .notDetermined ||
                CLLocationManager.authorizationStatus() == .denied
            {
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = 0.5 // used to get the accuracy of the user location the less the value the more the accuracy
            locationManager.delegate = self
             locationManager.startUpdatingLocation() //used for updating the user location for every second
            
        }
        else
        {
            print("Please turn on location services or GPS")
        }
        
    }
    
    
    //MARK:- MAPAnnotation Delegates
    
    func mapAnnotations() {
      
        let location = CLLocationCoordinate2D(latitude: 30.9644, longitude:76.5148)
       
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        //Span is to get the latDelta and lonDelta the less the number the more the accuracy nearest location exact value
        
        self.mapObj.setRegion(region, animated: true)
        
        let pin = customPin(pinTitle: "SmartITVentures", pinSubTitle: "Ropar, Punjab, India", location: location)
        self.mapObj.addAnnotation(pin)
        self.mapObj.delegate = self
    }
    
    
    //below methods indicates to add the custom image as identification for annotations
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.image = UIImage(named:"pin")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("annotation title == \(String(describing: view.annotation?.title!))")
        //When user taps the annotation pin it gets the view animated with the title and subtitle etc..
    }
    
    
    
    
    //MARK:- CLLocation Delegates
    //The below  method indicates to track the user location for every second we used to get the user current lat and long using the CLLocationCordinate2D
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let region  = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        //here location[0] indicates the user last location
        
        print("Latitide == \(locations[0].coordinate.latitude) , Longitude == \(locations[0].coordinate.longitude)")
        
        self.mapObj.setRegion(region, animated: true) // after getting the info of location we need to set to the mapRegion to display data
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to load the location \(error.localizedDescription)")
        //when unable to read the user location
    }
    
    
}




//
//  OurMapVC.swift
//  iOSProject
//
//  Created by Sourabh Deshkulkarni on 5/4/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class OurMapVC: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate,ZoomingProtocol {
    @IBOutlet weak var mapView : MKMapView!
    //var parkList = Parks()
    var typeOfPlace = ""
    var locationManager: CLLocationManager?
    var places : [Place] = []
    var lattitude = ""
    var longitude = ""
    var locationArray: [String] = []
    func zoomOnAnnotation(annotation:MKAnnotation){
        tabBarController?.selectedViewController = self
        var view: MKPinAnnotationView
 let identifier = "Pin"
        //for park: MKAnnotation in parks {
            mapView.addAnnotation(annotation)
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.pinTintColor = MKPinAnnotationView.purplePinColor()
        view.animatesDrop = true
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        let leftButton = UIButton(type: .InfoLight)
        let rightButton = UIButton(type: .DetailDisclosure)
        leftButton.tag = 0
        rightButton.tag = 1
        view.leftCalloutAccessoryView = leftButton
        view.rightCalloutAccessoryView = rightButton
        //}
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250,250)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    @IBAction func zoomOut(sender: AnyObject) {
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        
    }
    
    
    func mapView(manager: CLLocationManager!, didUpdateLocations userLocation: MKUserLocation) {
        // self.activityIndicator.hidden = true;
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude), MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        let mkCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 20, 20)
        mapView.setRegion(mkCoordinateRegion, animated: true)
        // let currentLocation = locationManager!.location!.coordinate
        
        
    }
    @IBAction func zoomIn(sender: AnyObject) {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
        if let lat = locationManager!.location?.coordinate.latitude,
            lon = locationManager!.location?.coordinate.latitude {
            let currentLocation = locationManager!.location?.coordinate
            
            let latDelta:CLLocationDegrees = 0.05
            
            let lonDelta:CLLocationDegrees = 0.05
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(currentLocation!, span)
            
            mapView.setRegion(region, animated: false)
        }
    }
    
    

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        let identifier = "Pin"
        
        if annotation is MKUserLocation{
            return nil
        }
        // self.activityIndicator.hidden = true;
        if annotation !== mapView.userLocation{
            if let dequedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView{
                dequedView.annotation = annotation
                view = dequedView
                print("I am in deque")
                
            }else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.pinTintColor = MKPinAnnotationView.purplePinColor()
                view.animatesDrop = true
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let leftButton = UIButton(type: .InfoLight)
                let rightButton = UIButton(type: .DetailDisclosure)
                leftButton.tag = 0
                rightButton.tag = 1
                view.leftCalloutAccessoryView = leftButton
                view.rightCalloutAccessoryView = rightButton
                print("I am in else")
            }
            return view
        }
        return nil
        
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("I am in annotation tapped")
        print("Control tapped: \(control), tag number = \(control.tag)")
        
        
        let parkAnnotation = view.annotation as! Place
        
        switch control.tag {
            
        case 0: //left button
            
            if let url = NSURL(string: "https://www.google.com/"){
                // self.activityIndicator.hidden = false;
                // self.activityIndicator.startAnimating()
                UIApplication.sharedApplication().openURL(url)
                
            }else{
                
                print("URL Not found")
            }
            
        case 1: //right button
            
            let coordinate = locationManager!.location!.coordinate
            
            let url = String(format: "http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f", coordinate.latitude,coordinate.longitude,parkAnnotation.getLocation()!.coordinate.latitude,parkAnnotation.getLocation()!.coordinate.longitude)
            
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            
        default:
            
            break
            
        }
        
        
    }
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
//        if let lat = locationManager!.location?.coordinate.latitude,
//            lon = locationManager!.location?.coordinate.longitude {
//            print("\(lat) /// \(lon)")
//            
//            lattitude = String(lat)
//            longitude = String(lon)
//        }
        let array = NSUserDefaults.standardUserDefaults().arrayForKey("location") as? [String]
        if(array != nil){
            self.locationArray = array!
        }
        lattitude = locationArray[0]
        longitude = locationArray[1]
        for park: MKAnnotation in places {
            mapView.addAnnotation(park)
        }
        
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        mapView.showsUserLocation = true
        
        super.viewDidLoad()
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlayObject: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlayObject as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        //self.activityIndicator.hidden = true;
        return renderer
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

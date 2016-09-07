//  FavoritePlaces
//
//  Created by Bryan French on 7/31/15.
//  Copyright (c) 2015 Bryan French. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapVC: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate,ZoomingProtocol {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
        let array = NSUserDefaults.standardUserDefaults().arrayForKey("location") as? [String]
        if(array != nil){
            self.locationArray = array!
        }
        lattitude = locationArray[0]
        longitude = locationArray[1]
        if  let endpointPlaces = NSURL(string: "https://maps.googleapis.com/maps/api/place/search/json?location=\(lattitude),\(longitude)&radius=10000&types=\(typeOfPlace)&sensor=true&key=AIzaSyDS9VcjBcjC-f-HZxq6FZTxiQQ4P5cuF6M"){
            if let data = try? NSData(contentsOfURL: endpointPlaces, options: []) {
                let json = JSON(data: data)
                
                
                if var weather = json["next_page_token"].string {
                    
                } else {
                    //Print the error
                    print(json["results"]["icon"].error)
                }
                if let location = json["results"].array {
                    
                    for var i = 0; i < location.count ; i += 1 {
                        
                        let name = location[i]["name"].string
                        let latititude = location[i]["geometry"]["location"]["lat"].doubleValue
                        
                        let longitude = location[i]["geometry"]["location"]["lng"].doubleValue
                        let vicinity = location[i]["vicinity"].string
                        var rating = location[i]["rating"].string
                        if rating == nil{
                            rating = "Not Available"
                        }
                        let parkLocation = CLLocation(latitude: latititude, longitude: longitude)
                        //print("Park location: \(parkLocation)")
                        let p = Place(parkName: name!, location: parkLocation,link:name!,imageType:typeOfPlace,rating: rating!, vicinity:vicinity!)
                        places.append(p)
                                            }
                } else {
                    //Print the error
                    print("not present")
                }
                // }
            }
        }
        for place: MKAnnotation in places {
            mapView.addAnnotation(place)
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


//
//  reverseGeoVC.swift
//  TouristApp
//
//  Created by Sourabh Deshkulkarni on 5/9/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//


import UIKit
import CoreLocation
import MapKit
import Contacts

class reverseGeoVC: UIViewController {
    @IBOutlet weak var address:UITextField!
    @IBOutlet weak var city:UITextField!
    @IBOutlet weak var state:UITextField!
    @IBOutlet weak var zip:UITextField!
    var coords:CLLocationCoordinate2D!
    var places = [String]()
    
    var recoPlaces : [Place] = []
    var lattitude = ""
    var longitude = ""
    var weatherMain:Float = 0.0
    var weatherForecast = ""
    var currentWeather = ""
    var currentLocation = ""
    var weatherCondition = ""
    var locationArray: [String] = []
    override func viewWillAppear(animated: Bool) {
        //Set background image.
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "MainBackground2.jpg")
        self.view.insertSubview(backgroundImage, atIndex: 0)
    }
    //Function which accepts URL, unwraps JSON data 
    func runWebService (url:String) {
        if  let endpointPlacesReco = NSURL(string:url ){
            // print("I am inside reco condition")
            if let data = try? NSData(contentsOfURL: endpointPlacesReco, options: []) {
                let json = JSON(data: data)
                
                if let location = json["results"].array {
                    
                    for var i = 0; i < location.count ; i += 1 {
                        
                        let name = location[i]["name"].string
                        let latititude = location[i]["geometry"]["location"]["lat"].doubleValue
                        
                        let longitude = location[i]["geometry"]["location"]["lng"].doubleValue
                        let typeOfPlace = location[i]["types"][0].string
                        // print("Type of place in reco: \(typeOfPlace)")
                        let parkLocation = CLLocation(latitude: latititude, longitude: longitude)
                        //print("Park location: \(parkLocation)")
                        let vicinity = location[i]["vicinity"].string
                        var rating = location[i]["rating"].string
                        if rating == nil{
                            rating = "Not Available"
                        }
                        //print("Park location: \(parkLocation)")
                        let p = Place(parkName: name!, location: parkLocation,link:name!,imageType:typeOfPlace!,rating: rating!, vicinity: vicinity!)
                        // print("Reco places: \(p.getParkName())")
                        
                        recoPlaces.append(p)
                    }
                    
                    
                    
                } else {
                    //Print the error
                    print("not present")
                }
                // }
            }
        }
    }
    func showMap(){
        //print("\(lattitude)################\(longitude)")
        if  let endpoint = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lattitude)&lon=\(longitude)&appid=7261734f1656be90d7487b5447441b69"){
            if let data = try? NSData(contentsOfURL: endpoint, options: []) {
                let json = JSON(data: data)
                
                //
                if let weather = json["main"]["temp"].number {
                    //Do something you want
                    var currentWeath = weather.floatValue
                    currentWeath = currentWeath - 273.15
                    weatherMain = currentWeath
                    let str = " deg C"
                    currentWeather = String(currentWeath)+str
                    
                } else {
                    //Print the error
                    print(json["main"]["temp"].error)
                }
                
            }
        }
        //Get current location information.
        if  let endpoint2 = NSURL(string: "http://api.wunderground.com/api/18fe88358596eb1c/geolookup/q/\(lattitude),\(longitude).json"){
            if let data = try? NSData(contentsOfURL: endpoint2, options: []) {
                let json = JSON(data: data)
                
                
                if let location = json["location"]["city"].string {
                    
                    //currentLocation.text = location
                    currentLocation = location
                    
                } else {
                    //Print the error
                    print(json["name"].error)
                }
                // }
            }
        }
        //Get weather forecast
        if  let endpoint3 = NSURL(string: "http://api.wunderground.com/api/18fe88358596eb1c/forecast/q/\(lattitude),\(longitude).json"){
            if let data = try? NSData(contentsOfURL: endpoint3, options: []) {
                let json = JSON(data: data)
                
                
                if let forecast = json["forecast"]["txt_forecast"]["forecastday"][0]["fcttext"].string {
                    
                    //  weatherCondition.text = "Current weather conditions: "+forecast
                    weatherForecast = forecast
                    weatherCondition = "Current weather conditions: "+forecast
                    
                } else {
                    //Print the error
                    print(json["forecast"]["date"].error)
                }
                // }
            }
        }
        //Place recommendation based on weather condition
        if weatherMain > 10 {
            let type = "stadium"
            //print("I am in reco condition")
            let urlStadium = "https://maps.googleapis.com/maps/api/place/search/json?location=\(lattitude),\(longitude)&radius=10000&types=\(type)&sensor=true&key=AIzaSyDS9VcjBcjC-f-HZxq6FZTxiQQ4P5cuF6M"
            //print("Here is URL: \(url)")
            runWebService(urlStadium)
            let urlZoo = "https://maps.googleapis.com/maps/api/place/search/json?location=\(lattitude),\(longitude)&radius=10000&types=amusement_park&sensor=true&key=AIzaSyDS9VcjBcjC-f-HZxq6FZTxiQQ4P5cuF6M"
            runWebService(urlZoo)
            // print("Here is URL: \(url)")
        } else{
            let museumURL = "https://maps.googleapis.com/maps/api/place/search/json?location=\(lattitude),\(longitude)&radius=10000&types=art_gallery&sensor=true&key=AIzaSyDS9VcjBcjC-f-HZxq6FZTxiQQ4P5cuF6M"
            runWebService(museumURL)
            
            let artGalleryURL = "https://maps.googleapis.com/maps/api/place/search/json?location=\(lattitude),\(longitude)&radius=10000&types=art_gallery&sensor=true&key=AIzaSyDS9VcjBcjC-f-HZxq6FZTxiQQ4P5cuF6M"
            runWebService(artGalleryURL)
            
            
        }

    }
    //Get serached location information.
    @IBAction func getDirections(sender: AnyObject){
        
        let addressString = "\(address.text) \(city.text) \(state.text) \(zip.text)"
        let geocoder = CLGeocoder()
        // let addressString = "\(address.text) \(city.text) \(state.text) \(zip.text)"
        geocoder.geocodeAddressString(addressString, completionHandler: {(placemarks:[CLPlacemark]?,error:NSError?)->Void in
            if let placemark = placemarks?[0]{
                if let location = placemark.location{
                    self.coords = location.coordinate
                    //print("\(location.coordinate.latitude)###\(location.coordinate.longitude)")
                    self.lattitude = String(location.coordinate.latitude)
                    self.longitude = String(location.coordinate.longitude)
                    self.showMap()
                    NSUserDefaults.standardUserDefaults().setObject([], forKey: "location")
                    let f = NSUserDefaults.standardUserDefaults().arrayForKey("location") as? [String]
                    if(f != nil) {
                        self.locationArray = f!
                    } else {
                        self.locationArray = []
                    }
                    
                    
                    
                    //if !favoriteArray.contains(place.getParkName()+"/"+place.getImageType()) {
                        self.locationArray.append(String(location.coordinate.latitude))
                        self.locationArray.append(String(location.coordinate.longitude))
                    NSUserDefaults.standardUserDefaults().setObject(self.locationArray, forKey: "location")
                    //}
                    self.performSegueWithIdentifier("reverseGeoSegue", sender: self)
                }
            }
        })
        
        
        
       
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!){
        if(segue.identifier == "reverseGeoSegue"){
            let svc = segue!.destinationViewController as! ViewController;
            
            svc.recoPlaces = recoPlaces
            svc.currentLocationString = currentLocation
            svc.currentWeatherString = currentWeather
            svc.weatherConditionString = weatherCondition
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

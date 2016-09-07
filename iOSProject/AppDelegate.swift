//
//  AppDelegate.swift
//  iOSProject
//
//  Created by Sourabh Deshkulkarni on 4/30/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
//var parks : [Park] = []
    var locationManager: CLLocationManager?
    var recoPlaces : [Place] = []
    var lattitude = ""
    var longitude = ""
    var weatherMain:Float = 0.0
    var window: UIWindow?
    var tabBarController:UITabBarController?
    var weatherForecast = ""
    func loadData(){
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
        if let lat = locationManager!.location?.coordinate.latitude,
            lon = locationManager!.location?.coordinate.longitude {
            print("\(lat) /// \(lon)")
            
            lattitude = String(lat)
            longitude = String(lon)
            
            if  let endpoint = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=7261734f1656be90d7487b5447441b69"){
                if let data = try? NSData(contentsOfURL: endpoint, options: []) {
                    let json = JSON(data: data)
                    
                    //
                    if var weather = json["main"]["temp_max"].number {
                        //Do something you want
                        var currentWeath = weather.floatValue
                        currentWeath = currentWeath - 273.15
                        weatherMain = currentWeath
                       
                        
                    }
                    else {
                        //Print the error
                        print(json["main"]["temp_max"].error)
                    }
                    
                }
            }
            if  let endpoint3 = NSURL(string: "http://api.wunderground.com/api/18fe88358596eb1c/forecast/q/\(lattitude),\(longitude).json"){
                if let data = try? NSData(contentsOfURL: endpoint3, options: []) {
                    let json = JSON(data: data)
                    
                    
                    if let forecast = json["forecast"]["txt_forecast"]["forecastday"][0]["fcttext"].string {
                        
                        //  weatherCondition.text = "Current weather conditions: "+forecast
                        weatherForecast = forecast
                       // weatherCondition = "Current weather conditions: "+forecast
                        
                    } else {
                        //Print the error
                        print(json["forecast"]["date"].error)
                    }
                    // }
                }
            }
           
            
            if weatherMain > 10 && weatherForecast.lowercaseString.rangeOfString("sun") != nil && weatherForecast.lowercaseString.rangeOfString("clear") != nil{
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
        

    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        loadData()
        //let f = NSUserDefaults.standardUserDefaults().arrayForKey("location") as? [String]
       // f = []
        NSUserDefaults.standardUserDefaults().setObject([], forKey: "location")
        tabBarController = self.window?.rootViewController as?
        UITabBarController

        let mapVC = tabBarController!.viewControllers![3] as! OurMapVC
        mapVC.places = recoPlaces
        
        let navVC = tabBarController!.viewControllers![0] as! UINavigationController
        let tableVC = navVC.viewControllers[0] as! LogInViewController
        
        
        tableVC.recoPlaces = recoPlaces
        //tableVC.mapVC = mapVC

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
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


}


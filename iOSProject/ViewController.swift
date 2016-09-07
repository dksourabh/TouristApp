//
//  ViewController.swift
//  iOSProject
//
//  Created by Sourabh Deshkulkarni on 4/30/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import CoreLocation
import LocalAuthentication
//import GoogleMaps

class ViewController: UIViewController,CLLocationManagerDelegate, UITabBarControllerDelegate {
    
    
    var locationManager: CLLocationManager?
    @IBOutlet weak var currentLocation: UILabel!
    
    @IBOutlet weak var weatherCondition: UITextView!
    @IBOutlet weak var currentWeather: UILabel!
    var places = [String]()
    
    var recoPlaces : [Place] = []
    var lattitude = ""
    var longitude = ""
    var weatherMain:Float = 0.0
   // var weatherForecast = ""
    
    var weatherForecast = ""
    var currentWeatherString = ""
    var currentLocationString = ""
    var weatherConditionString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        //self.navigationController?.popToRootViewControllerAnimated(true)

        // Do any additional setup after loading the view, typically from a nib.
    }
    

    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if let viewController = viewController as? UINavigationController {
            viewController.popToRootViewControllerAnimated(true)
        }
    }


    
    
   
    override func viewWillAppear(animated: Bool) {
        
        currentWeather.text = currentWeatherString
        weatherCondition.text = weatherConditionString
        currentLocation.text = currentLocationString

        if weatherConditionString.lowercaseString.rangeOfString("sun") != nil  || weatherConditionString.lowercaseString.rangeOfString("clear") != nil {
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "sunny.jpg")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        }else if weatherConditionString.lowercaseString.rangeOfString("cloud") != nil{
            let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
            backgroundImage.image = UIImage(named: "cloudy.jpg")
            self.view.insertSubview(backgroundImage, atIndex: 0)
        }else if weatherConditionString.lowercaseString.rangeOfString("rain") != nil || weatherConditionString.lowercaseString.rangeOfString("shower") != nil{
            let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
            backgroundImage.image = UIImage(named: "rainy.jpg")
            self.view.insertSubview(backgroundImage, atIndex: 0)
        }else{
            let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
            backgroundImage.image = UIImage(named: "MainBackground2.jpg")
            self.view.insertSubview(backgroundImage, atIndex: 0)
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

            override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!){
                if(segue.identifier == "recoPlacesSegue"){
                    let svc = segue!.destinationViewController as! RecoPlacesTableVC;
                    
                    svc.recoPlaces = recoPlaces
                    
                }
    }

            //
            
    }





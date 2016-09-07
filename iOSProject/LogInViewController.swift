//
//  LogInViewController.swift
//  iOSProject
//
//  Created by Sourabh Deshkulkarni on 5/5/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreLocation
class LogInViewController: UIViewController, UIAlertViewDelegate,CLLocationManagerDelegate {
     var locationManager: CLLocationManager?
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
    /**
     This method gets called when the users clicks on the
     login button in the user interface.
     
     - parameter sender: a reference to the button that has been touched
     
     
     */
    
    @IBAction func guestLoginClicked(sender:UIButton){
       // dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("authenticationSegue", sender: self)
        //}

    }
    @IBAction func loginButtonClicked(sender: UIButton) {
        
        // 1. Create a authentication context
        let authenticationContext = LAContext()
        var error:NSError?
        
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        guard authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
            
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
            
        }
        
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .DeviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Only awesome people are allowed",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    
                    // Fingerprint recognized
                    // Go to view controller
                    //self.navigateToAuthenticatedViewController()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("authenticationSegue", sender: self)
                    }
                    
                }else {
                    
                    // Check if there is an error
                    if let error = error {
                        
//                        let message = self.errorMessageForLAErrorCode(error.code)
//                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                        print(error.localizedDescription)
                        
                        switch error.code {
                            
                        case LAError.SystemCancel.rawValue:
                            print("Authentication was cancelled by the system")
                            
                        case LAError.UserCancel.rawValue:
                            print("Authentication was cancelled by the user")
                            
                        case LAError.UserFallback.rawValue:
                            print("User selected to enter custom password")
                            self.showPasswordAlert()
                            
                        default:
                            print("Authentication failed")
                            self.showPasswordAlert()
                        }
                        
                    }
                    
                }
                
            })
        
    }
    
    /**
     This method will present an UIAlertViewController to inform the user that the device has not a TouchID sensor.
     */
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle("Error", message: "This device does not have a TouchID sensor.")
        
    }
    func showPasswordAlert() {
        let passwordAlert : UIAlertView = UIAlertView(title: "TouchIDDemo", message: "Please type your password", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Okay")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    /**
     This method will present an UIAlertViewController to inform the user that there was a problem with the TouchID sensor.
     
     - parameter error: the error message
     
     */
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        
        showAlertWithTitle("Error", message: message)
        
    }
    
    /**
     This method presents an UIAlertViewController to the user.
     
     - parameter title:  The title for the UIAlertViewController.
     - parameter message:The message for the UIAlertViewController.
     
     */
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.presentViewController(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    /**
     This method will return an error message string for the provided error code.
     The method check the error code against all cases described in the `LAError` enum.
     If the error code can't be found, a default message is returned.
     
     - parameter errorCode: the error code
     - returns: the error message
     */
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.AppCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.AuthenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.InvalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.PasscodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.SystemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.TouchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.TouchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.UserCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.UserFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
    override func viewWillAppear(animated: Bool) {
    let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
    backgroundImage.image = UIImage(named: "MainBackground2.jpg")
    self.view.insertSubview(backgroundImage, atIndex: 0)
        
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
            NSUserDefaults.standardUserDefaults().setObject([], forKey: "location")
            let f = NSUserDefaults.standardUserDefaults().arrayForKey("location") as? [String]
            if(f != nil) {
                self.locationArray = f!
            } else {
                self.locationArray = []
            }
            
            
            
            //if !favoriteArray.contains(place.getParkName()+"/"+place.getImageType()) {
            self.locationArray.append(lattitude)
            self.locationArray.append(longitude)
            NSUserDefaults.standardUserDefaults().setObject(self.locationArray, forKey: "location")
            
            if  let endpoint = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=7261734f1656be90d7487b5447441b69"){
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
            if  let endpoint2 = NSURL(string: "http://api.wunderground.com/api/18fe88358596eb1c/geolookup/q/\(lat),\(lon).json"){
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
            if  let endpoint3 = NSURL(string: "http://api.wunderground.com/api/18fe88358596eb1c/forecast/q/\(lat),\(lon).json"){
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
            
    }
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!){
        if(segue.identifier == "authenticationSegue"){
            let svc = segue!.destinationViewController as! ViewController;
            
            svc.recoPlaces = recoPlaces
            svc.currentLocationString = currentLocation
            svc.currentWeatherString = currentWeather
            svc.weatherConditionString = weatherCondition
            svc.lattitude = lattitude
            svc.longitude = longitude
            
        }
    }
    /**
     This method will push the authenticated view controller onto the UINavigationController stack
     */
    func navigateToAuthenticatedViewController(){
        
        if let loggedInVC = storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController") {
           // storyboard?.
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                self.navigationController?.pushViewController(loggedInVC, animated: true)
                
            }
            
        }
        
    }


}

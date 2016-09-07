//
//  RecoPlacesTableVC.swift
//  iOSProject
//
//  Created by Sourabh Deshkulkarni on 5/4/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import CoreLocation
class RecoPlacesTableVC: UITableViewController,CLLocationManagerDelegate {
    var mapVC:MapVC!
    //var places:[String] = []
    var typeOfPlace = ""
    //var lattitude:String = ""
    var locationManager: CLLocationManager?
    //var longitude:String = ""
    var recoPlaces : [Place] = []
    override func viewWillAppear(animated: Bool) {
        print("I am in Reco VC")
        
        
    }
    override func viewDidLoad() {
//        locationManager = CLLocationManager()
//        locationManager!.delegate = self
//        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager!.requestAlwaysAuthorization()
//        locationManager!.startUpdatingLocation()
//        if let lat = locationManager!.location?.coordinate.latitude,
//            lon = locationManager!.location?.coordinate.longitude {
//            print("\(lat) /// \(lon)")
//            
//            lattitude = String(lat)
//            longitude = String(lon)
//        }
        super.viewDidLoad()
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("in Number of sections")
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("in Number of rows: \(recoPlaces.count)")
        return recoPlaces.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("recommendedCell", forIndexPath: indexPath)
        
        
        let place = recoPlaces[indexPath.row]
        print("Individual park: \(place.getParkName())")
        //        let parkLocation = park.getLocation()
        //        let distance = myLocation.distanceFromLocation(parkLocation!) / 1000
        cell.textLabel?.text = place.getParkName()
        //park.setDistanceFromCurrentLocation(distance)
        // cell.detailTextLabel?.text = "\(park.getDistanceFromCurrentLocation())"
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let place = recoPlaces[indexPath.row]
        let detailVC = PlaceSpecificTableVC(style: .Grouped)
        detailVC.title = place.title
        detailVC.place = place
        detailVC.zoomDelegate = mapVC
        navigationController?.pushViewController(detailVC, animated: true)
        
    }

}

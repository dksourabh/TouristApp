//
//  PlacesDetailVC.swift
//  iOSProject
//
//  Created by Sourabh Deshkulkarni on 4/30/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import CoreLocation
class PlacesDetailVC: UITableViewController,CLLocationManagerDelegate{
var mapVC:MapVC!
    //var places:[String] = []
    var typeOfPlace = ""
    var lattitude:String = ""
     var locationManager: CLLocationManager?
    var longitude:String = ""
    var places : [Place] = []
    override func viewWillAppear(animated: Bool) {
        print("I am in detail VC")
        if  let endpointPlaces = NSURL(string: "https://maps.googleapis.com/maps/api/place/search/json?location=\(lattitude),\(longitude)&radius=40000&types=\(typeOfPlace)&sensor=true&key=AIzaSyDS9VcjBcjC-f-HZxq6FZTxiQQ4P5cuF6M"){
            if let data = try? NSData(contentsOfURL: endpointPlaces, options: []) {
                let json = JSON(data: data)
                
                if let location = json["results"].array {
                    //Do something you want
                    //currentLocation.text = location
                    // print("Location is \(location[0]["name"])")
                    for i in 0 ..< location.count  {
                        
                        let name = location[i]["name"].string
                        let latititude = location[i]["geometry"]["location"]["lat"].doubleValue
                        
                        let longitude = location[i]["geometry"]["location"]["lng"].doubleValue
                        let parkLocation = CLLocation(latitude: latititude, longitude: longitude)
                       // print("Park id: \(location[i]["place_id"])")
                        let vicinity = location[i]["vicinity"].string
                        var rating = location[i]["rating"].string
                        if rating == nil{
                            rating = "Not Available"
                        }
                        //Fetching place information
                        let p = Place(parkName: name!, location: parkLocation,link:name!,imageType:typeOfPlace, rating: rating!, vicinity:vicinity!)
                        places.append(p)
                        //                        print("Bar names for TableView: \(name)")
                        //                        parks.append(p)
                    }
                } else {
                    //Print the error
                    print("not present")
                }
                // }
            }
        }
        
    }
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()

                super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print("in Number of sections")
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("in Number of rows")
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier:"resuseIdentifier")
        }
        
        
        let place = places[indexPath.row]
       
        cell!.textLabel?.text = place.getParkName()
        
        cell!.accessoryType = .DisclosureIndicator
        
        return cell!
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let place = places[indexPath.row]
        let detailVC = PlaceSpecificTableVC(style: .Grouped)
        detailVC.title = place.title
        detailVC.place = place
        detailVC.zoomDelegate = mapVC
        navigationController?.pushViewController(detailVC, animated: true)
        
    }

}

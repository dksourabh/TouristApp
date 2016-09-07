//
//  FavoritesTableVC.swift
//  iOSProject
//
//  Created by Sourabh Deshkulkarni on 5/3/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import CoreLocation
import Social
class FavoritesTableVC: UITableViewController,CLLocationManagerDelegate {

    var mapVC:MapVC!
    var placeList = Places()
    var favArray:[String] = []
    var typeOfPlace:String = ""
    var locationManager: CLLocationManager?
    var lattitude = ""
    var longitude = ""
    // var locationManager: CLLocationManager?
    var places : [Place] = []
    override func viewWillAppear(animated: Bool) {
        //Fetch favorite places array from NSUserDefaults
        let array = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String]
        if(array != nil){
            self.favArray = array!
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.reloadData()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let array = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String]
        return (favArray.count)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell", forIndexPath: indexPath)
       
        let fullName = favArray[indexPath.row]

        let fullNameArr = fullName.characters.split{$0 == "/"}.map(String.init)
        cell.textLabel?.text = fullNameArr[0]
        print("Type of place in favorite: \(fullNameArr[1])")
        typeOfPlace = fullNameArr[1]
        // cell.detailTextLabel?.text = "\(distance)"
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    
   
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            favArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        }
        if  let endpointPlaces = NSURL(string: "https://maps.googleapis.com/maps/api/place/search/json?location=\(lattitude),\(longitude)&radius=10000&types=\(typeOfPlace)&sensor=true&key=AIzaSyDS9VcjBcjC-f-HZxq6FZTxiQQ4P5cuF6M"){
            if let data = try? NSData(contentsOfURL: endpointPlaces, options: []) {
                let json = JSON(data: data)
                
                // if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                // we're OK to parse!
                //print(json)
                
                //Get latitude and longitude of the place.
                if let location = json["results"].array {
                    //Do something you want
                    //currentLocation.text = location
                    // print("Location is \(location[0]["name"])")
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
                        let p = Place(parkName: name!, location: parkLocation,link:name!,imageType:typeOfPlace,rating: rating!,vicinity:vicinity!)
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
        let favoriteParkName = favArray[indexPath.row];
        let fullNameArr = favoriteParkName.characters.split{$0 == "/"}.map(String.init)
      let placeName = fullNameArr[0]
        var arrayIndex = 0
        for var i = 0; i < places.count ; i += 1 {
            let parkName = places[i].getParkName()
            if parkName == placeName {
                arrayIndex = i
            }
            
        }
        
        let place = places[arrayIndex]
        let detailVC = PlaceSpecificTableVC(style: .Grouped)
        detailVC.title = place.title
        detailVC.place = place
        detailVC.zoomDelegate = mapVC
        navigationController?.pushViewController(detailVC, animated: true)
        
    }

}

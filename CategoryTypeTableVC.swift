//
//  CategoryTypeTableVCTableViewController.swift
//  iOSProject
//
//  Created by Sourabh Deshkulkarni on 5/3/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit

class CategoryTypeTableVC: UITableViewController {
    var PlaceCategories:[String] = []
    var lattitude = ""
    var longitude = ""
    var locationArray: [String] = []
    var typeOfPlace = ""
    @IBAction func mapview(sender: UIButton) {
    }
    
    override func viewWillAppear(animated: Bool) {
        //Adding different places categories.
        PlaceCategories.append("bank")
        PlaceCategories.append("airport")
        PlaceCategories.append("hospital")
        PlaceCategories.append("cafe")
        PlaceCategories.append("museum")
        PlaceCategories.append("restaurant")
        PlaceCategories.append("gas_station")
        PlaceCategories.append("convenience_store")
        PlaceCategories.append("bar")
        PlaceCategories.append("park")
        PlaceCategories.append("movie_theater")
        PlaceCategories.append("night_club")
        PlaceCategories.append("bowling_alley")
        PlaceCategories.append("art_gallery")
        PlaceCategories.append("hindu_temple")
        PlaceCategories.append("school")
        PlaceCategories.append("police")
        PlaceCategories.append("university")
        PlaceCategories.append("church")
        PlaceCategories.append("atm")
        PlaceCategories.append("casino")
        PlaceCategories.append("zoo")
        PlaceCategories.append("amusement_park")
        PlaceCategories.append("campground")
        PlaceCategories.append("car_wash")
        PlaceCategories.append("grocery_or_supermarket")
        PlaceCategories.append("shopping_mall")
        PlaceCategories.append("beauty_salon")
        PlaceCategories.append("meal_takeaway")
        PlaceCategories.append("subway_station")
        PlaceCategories.append("transit_station")
        PlaceCategories.append("clothing_store")
        PlaceCategories.append("car_repair")
        PlaceCategories.append("post_office")
        let array = NSUserDefaults.standardUserDefaults().arrayForKey("location") as? [String]
        if(array != nil){
            self.locationArray = array!
        }
        
    }
    override func viewDidLoad() {
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
        
        return PlaceCategories.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TypeCell", forIndexPath: indexPath) as! TableViewCell
        
       
        let category = PlaceCategories[indexPath.row]
        print("Individual category: \(category)")
        //        let parkLocation = park.getLocation()
        //        let distance = myLocation.distanceFromLocation(parkLocation!) / 1000
         cell.titleLabel.text = category
        typeOfPlace = category
        //park.setDistanceFromCurrentLocation(distance)
        // cell.detailTextLabel?.text = "\(park.getDistanceFromCurrentLocation())"
        cell.accessoryType = .DisclosureIndicator
        
        
        cell.logButton.tag = indexPath.row;
        cell.logButton.addTarget(self, action: "openMapView:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    @IBAction func openMapView (sender: UIButton!) {
//        var svc = segue!.destinationViewController as! MapVC;
//        
//        svc.typeOfPlace = PlaceCategories[sender.tag]
        performSegueWithIdentifier("mapSegue", sender: sender)
        
    }
    
    
  
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let typeOfPlace = PlaceCategories[indexPath.row]
        let detailVC = PlacesDetailVC(style: .Grouped)
        detailVC.typeOfPlace = typeOfPlace
        lattitude = locationArray[0]
        longitude = locationArray[1]
        detailVC.lattitude = lattitude
        detailVC.longitude = longitude
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "mapSegue") {
            let svc = segue!.destinationViewController as! MapVC;
            
            svc.typeOfPlace = PlaceCategories[sender.tag]

            
        
        
    }


}
}

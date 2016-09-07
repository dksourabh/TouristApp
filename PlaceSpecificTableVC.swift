//
//  PlaceSpecificTableVC.swift
//  iOSProject
//
//  Created by Sourabh Deshkulkarni on 5/3/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//

import UIKit
import Social
let LANDMARK_SECTION = 0
let SHOW_ON_MAP = 2
let ADD_TO_FAVORITES = 3
let RATING_SECTION = 4
let VICINITY_SECTION = 1
let SHARE_ON_MEDIA = 5
var favoriteArray: [String] = []
class PlaceSpecificTableVC: UITableViewController {
    var place:Place!
    var mapVC:OurMapVC!
    var zoomDelegate:ZoomingProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //var
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     
            return 44.0
      //  }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
            return 1
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //doing programatically instead of vis storyboard.
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier:"resuseIdentifier")
        }
        switch indexPath.section {
        case LANDMARK_SECTION:
            //let data = [park.getParkName()]
            cell!.textLabel?.text = place.getParkName()
            
        case VICINITY_SECTION:
            cell!.textLabel?.text = place.getVicinity()
//            cell!.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
//            cell?.textLabel?.numberOfLines = 10
        case SHOW_ON_MAP:
            cell!.textLabel?.text = "SHOW ON MAP"
        case ADD_TO_FAVORITES:
            cell!.textLabel?.text = "ADD TO FAVORITES"
        case RATING_SECTION:
            cell!.textLabel?.text = place.getRating()
        case SHARE_ON_MEDIA:
            cell!.textLabel?.text = "SHARE"

        default:
            break
        }
        // Configure the cell...
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        switch section {
        case LANDMARK_SECTION:
            title = "Place Details"
        case VICINITY_SECTION:
            title = "Place Vicinity"
        case RATING_SECTION:
            title = "Place Rating"
        case SHARE_ON_MEDIA:
            title = "Social Media"
        default:
            break
        }
        return title
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var msg = ""
        switch indexPath.section {
        case LANDMARK_SECTION:
            msg = "You tapped Landmark Name"
        case VICINITY_SECTION:
            msg = "You tapped Landmark State"
        case SHOW_ON_MAP:
            msg = "You tapped Landmark Coordinates"
          
                       let appDel = UIApplication.sharedApplication().delegate as! AppDelegate;
                        (appDel.tabBarController?.viewControllers![3] as! OurMapVC).zoomOnAnnotation(place)
        case ADD_TO_FAVORITES:
            let alert = UIAlertController(title: "Added to Favorites", message: msg, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title:"OK", style: .Default, handler: nil)
            alert.addAction(OKAction)
            presentViewController(alert, animated: true, completion: nil)
            let f = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String]
            if(f != nil) {
                favoriteArray = f!
            } else {
                favoriteArray = []
            }
            
            
            
            if !favoriteArray.contains(place.getParkName()+"/"+place.getImageType()) {
                favoriteArray.append(place.getParkName()+"/"+place.getImageType())
            }
           
            NSUserDefaults.standardUserDefaults().setObject(favoriteArray, forKey: "favorites")
        //park.setIsFavorite("Yes")
            
        case SHARE_ON_MEDIA:
//            if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)) {
//                let socialController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//                socialController.setInitialText("I am at this awesome place \(place.getParkName())")
//                self.presentViewController(socialController, animated: true, completion: nil)
//            }
            //let image = customView.createImageFromContext()
            let message = "I am at this awesome place \(place.getParkName())"
            let postItems = [message]
            let activityVC = UIActivityViewController(activityItems: postItems, applicationActivities: nil)
            presentViewController(activityVC, animated: true, completion: nil)
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    }

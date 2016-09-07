//
//  Park.swift
//  NPF-1
//
//  Created by Sourabh Deshkulkarni on 2/8/16.
//  Copyright © 2016 Sourabh Deshkulkarni. All rights reserved.
//
import Foundation
import CoreLocation
import MapKit

class Place :NSObject,  MKAnnotation {
    
    private var location : CLLocation?
    
    private var imageLink : String = ""
    
    private var parkDescription : String = ""
    
    private var parkName : String = ""
    
    private var parkLocation : String = ""
    
    private var dateFormed : String = ""
    
    private var area : String = ""
    
    private var link : String = ""
    private var imageName: String = ""
    private var imageSize: String = ""
    private var imageType: String = ""
    private var rating: String = ""
    private var vicinity: String = ""
    private var distanceFromCurrentLocation: Double = 0
    
    @objc var coordinate: CLLocationCoordinate2D {
        get {
            return location!.coordinate
        }
    }
    func getRating() -> String {
        return rating
    }
    func getVicinity() -> String {
        return vicinity
    }
    func setRating(value:String){
        self.rating=value
    }
    func setVicinity(value:String){
        self.vicinity=value
    }
    func getDistanceFromCurrentLocation()-> Double {
        return distanceFromCurrentLocation
    }
    func getImageName()-> String {
        return imageName
    }
    func getImageSize() -> String {
        return imageSize
    }
    func getImageType() -> String {
        return imageType
    }
    func setImageName(value: String){
        imageName=value
    }
    func setImageSize(value: String){
        imageSize=value
    }
    func setImageType(value: String){
        imageType=value
    }
    @objc var title : String? {
        get {
            return link
        }
    }
    
    @objc var subtitle : String? {
        get {
            return parkName
        }
    }
    
    
    init(parkName: String,location: CLLocation?,link:String,imageType:String,rating:String,vicinity:String){
        self.parkName = parkName
        
        self.location = location
        self.link = link
        self.imageType = imageType
        self.rating = rating
        self.vicinity = vicinity
        
        
        
    }
    convenience override init () {
        
        self.init(parkName: "Unknown", location: nil, link: "Unknwon", imageType: "Unknwon", rating: "Unknwon", vicinity: "Unknwon")
        
    }
    
    func getParkName() -> String {
        return parkName
    }
    
    
    func setParkName(value: String) {
        let length = value.characters.count
        
        let startIndex = value.startIndex
        
        let endIndex = value.startIndex.advancedBy(length-1)
        value[endIndex] // returns Character 'o'
        value[startIndex]
        if((value.characters.count)>75 || (value.characters.count)<3 || value[endIndex] == " " || value[startIndex] == " ")
        {
            print(" Bad value of \(value) in setParkLocation: setting to TBD")
            parkLocation = "TBD"
        }
        else
        {
            parkLocation = value
        }
    }
    func getParkLocation()->String{
        return parkLocation
    }
    func setParkLocation(value: String){
        let length = value.characters.count
        if length > 3 && length < 75 && value != ""{
            parkLocation = value}
        else{
            parkLocation = "TBD"
            print("Bad value of \(value) in setParkLocation: setting to TBD")}
        
    }
    func getDateFormed()->String{
        return dateFormed
    }
    func setDateFormed(value: String){
        dateFormed=value
    }
    func getArea()->String{
        return area
    }
    func setArea(value:String){
        area=value
    }
    func getLink()->String{
        return link
    }
    func setLink(value:String){
        link=value
    }
    func getParkDescription()->String{
        return parkDescription
    }
    func setParkDescription(value:String){
        self.parkDescription = value
    }
    func getImageLink()->String{
        return imageLink
    }
    func setImageLink(value:String){
        self.imageLink=value
    }
    func setDistanceFromCurrentLocation(value:Double){
        self.distanceFromCurrentLocation = value
    }
    func getLocation()->CLLocation?{
        return location
    }
    func setLocation(value: CLLocation){
        self.location = value
    }
     override  var description: String{
        return " \n Park Name:\(parkName), \n Park location: \(parkLocation), \n Date Formed:\(dateFormed), \n area:\(area), \n link: \(link), \n location: \(location), \n Image Link: \(imageLink), \n Park Description: \(parkDescription)"
    }
    
    

}

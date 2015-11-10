//
//  Model.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 10/20/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import Foundation
import MapKit

struct BuildingKey {
    static let Title = "name"
    static let Latitude = "latitude"
    static let Longitude = "longitude"
    static let Coordinate = "coordinate"
    static let Image = "photo"
    static let YearConstructed = "year_constructed"
    static let Favorite = "favorite"
}

class Building : NSObject, MKAnnotation, NSCoding {
    var title : String?
    var subtitle : String?
    var coordinate : CLLocationCoordinate2D
    var latitude : CLLocationDegrees
    var longitude : CLLocationDegrees
    var isFavorite : Bool
    var yearConstructed : Int
    var image : UIImage
    
    init (title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, yearConstructed: Int, image: UIImage, favorite: Bool, subtitle:String){
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.yearConstructed = yearConstructed
        self.image = UIImage(named: "NoImageAvailable.png")!
        self.isFavorite = false
        
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: BuildingKey.Title)
        aCoder.encodeDouble(latitude, forKey: BuildingKey.Latitude)
        aCoder.encodeDouble(longitude, forKey: BuildingKey.Longitude)
        aCoder.encodeInteger(yearConstructed, forKey: BuildingKey.YearConstructed)
        aCoder.encodeObject(image, forKey: BuildingKey.Image)
        aCoder.encodeObject(isFavorite, forKey: BuildingKey.Favorite)
    }
    required convenience init(coder aDecoder: NSCoder) {
        let t = aDecoder.decodeObjectForKey(BuildingKey.Title) as! String
        let lat = aDecoder.decodeObjectForKey(BuildingKey.Latitude) as! CLLocationDegrees
        let lon = aDecoder.decodeObjectForKey(BuildingKey.Longitude) as! CLLocationDegrees
        let y = aDecoder.decodeIntegerForKey(BuildingKey.YearConstructed)
        let i = aDecoder.decodeObjectForKey(BuildingKey.Image) as! UIImage
        let f = aDecoder.decodeObjectForKey(BuildingKey.Favorite) as! Bool
        
        self.init(title: t, latitude: lat, longitude: lon, yearConstructed: y, image: i, favorite: f, subtitle: "")
    }
    
}

class Model {
    
    static let sharedInstance = Model()
    private let buildingsArray : [Building]
    private let buildingsDictionary : [String:[Building]]
    private let fileName : String = "buildings"
    private let allKeys : [String]
    var archivePath : String
    
    private var favoriteBuildings = [Building]()
    private var userPlottedPins = [Building]()
    
    init() {
        let fileManager = NSFileManager.defaultManager()
        let URLS = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let URL = URLS[0]
        archivePath = URL.URLByAppendingPathComponent(fileName).path!
        
        if fileManager.fileExistsAtPath(archivePath) {
            buildingsArray = NSKeyedUnarchiver.unarchiveObjectWithFile(archivePath) as! [Building]
        } else {
            let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist")
            let data = NSArray(contentsOfFile: path!) as! [[String:AnyObject]]
            
            var _buildings = [Building]()
            
            
            for dictionary in data {
                //let building = Building(title: dictionary["name"] as! String, coordinate: CLLocationCoordinate2D(latitude: dictionary["latitude"] as! CLLocationDegrees, longitude: dictionary["longitude"] as! CLLocationDegrees), subtitle: "")
                let imageName = dictionary["photo"] as! String
                let image : UIImage
                if imageName != "" {
                    image = UIImage(named: "\(imageName).jpg")!
                    //building.image = UIImage(named: "\(image).jpg")!
                } else {
                    image = UIImage(named: "NoImageAvailable.png")!
                }
                //building.yearConstructed = dictionary["year_constructed"] as! Int
                
                let building = Building(title: dictionary["name"] as! String, latitude: dictionary["latitude"] as! CLLocationDegrees, longitude: dictionary["longitude"] as! CLLocationDegrees, yearConstructed: dictionary["year_constructed"] as! Int, image: image, favorite: false, subtitle: "")
                _buildings.append(building)
                
                
            }
            buildingsArray = _buildings
            
        }
        
        var _buildingsDictionary = [String:[Building]]()
        
        for building in buildingsArray {
            let firstLetter = building.title!.firstLetter()!
            if let _ = _buildingsDictionary[firstLetter] {
                _buildingsDictionary[firstLetter]!.append(building)
            } else {
                _buildingsDictionary[firstLetter] = [building]
            }
        }
        
        
        buildingsDictionary = _buildingsDictionary
        let keys = Array(buildingsDictionary.keys)
        allKeys = keys.sort()
    }
    
    func saveArchive(){
        NSKeyedArchiver.archiveRootObject(buildingsArray, toFile: archivePath)
    }
    
    func numberOfTableSections() -> Int {
        return allKeys.count
    }
    
    func letterForSection(section:Int) -> String {
        return allKeys[section]
    }
    
    func buildingsInSection(section: Int) -> [Building]{
        let letterInSection = letterForSection(section)
        var buildings = buildingsDictionary[letterInSection]!
        buildings.sortInPlace { ($0.title < $1.title)}
        return buildings
    }
    
    func numberOfBuildingsInSection(section: Int) -> Int{
        let buildings : [Building] = buildingsInSection(section)
        return buildings.count
    }
    
    func buildingAtIndexPath(indexPath : NSIndexPath) -> Building{
        var buildings : [Building] = buildingsInSection(indexPath.section)
        //buildings.sortInPlace { ($0.title < $1.title)}
        return buildings[indexPath.row]
    }
    
    func indexTitles() -> [String] {
        return allKeys
    }
    
    func isFavoriteBuildingAtIndexPath(indexPath: NSIndexPath) -> Bool {
        let buildings : [Building] = buildingsInSection(indexPath.section)
        return buildings[indexPath.row].isFavorite
    }
    
    func toggleIsFavoriteBuildingAtIndexPath(indexPath: NSIndexPath) {
        let buildings : [Building] = buildingsInSection(indexPath.section)
        buildings[indexPath.row].isFavorite = !buildings[indexPath.row].isFavorite
    }
    
    func favoriteBuildingsToPlot() -> [Building] {
        return favoriteBuildings
    }
    
    func userPlottedPinsToPlot() -> [Building] {
        return userPlottedPins
    }
    
    func addUserAddedPin(building: Building){
        userPlottedPins.append(building)
    }
    
    func addFavorite(building: Building) {
        favoriteBuildings.append(building)
        
    }
    
    func updateImageForBuildingWithTitle(image : UIImage, title : String){
        for building in buildingsArray {
            if building.title == title {
                building.image = image
            }
        }
    }
    
    func yearConstructedForBuildingWithTitle(title : String) -> Int{
        for building in buildingsArray{
            if building.title == title {
                return building.yearConstructed
            }
        }
        return 0
    }
    
    func removeUserPlottedPin(building: Building) {
        var index : Int = 0
        for aBuilding in userPlottedPins {
            if aBuilding.title == building.title {
                break
            }
            index++
        }
        userPlottedPins.removeAtIndex(index)
    }
    
    func removeFavorite(building: Building) {
        var index : Int = 0
        for aBuilding in favoriteBuildings {
            if aBuilding.title == building.title {
                break
            }
            index++
        }
        favoriteBuildings.removeAtIndex(index)
    }
    
}










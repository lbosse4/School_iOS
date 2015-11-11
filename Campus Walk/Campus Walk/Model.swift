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
        self.image = image
        self.isFavorite = favorite
        
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
        let dataImage : NSData = UIImagePNGRepresentation(image)!
        aCoder.encodeObject(dataImage, forKey: BuildingKey.Image)
        aCoder.encodeObject(isFavorite, forKey: BuildingKey.Favorite)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let t = aDecoder.decodeObjectForKey(BuildingKey.Title) as! String
        let lat = aDecoder.decodeDoubleForKey(BuildingKey.Latitude)
        let lon = aDecoder.decodeDoubleForKey(BuildingKey.Longitude)
        let y = aDecoder.decodeIntegerForKey(BuildingKey.YearConstructed)
        let i = aDecoder.decodeObjectForKey(BuildingKey.Image) as! NSData
        let f = aDecoder.decodeObjectForKey(BuildingKey.Favorite) as! Bool
        
        self.init(title: t, latitude: lat, longitude: lon, yearConstructed: y, image: UIImage(data: i)!, favorite: f, subtitle: "")
    }
    
}

class Model {
    
    static let sharedInstance = Model()
    private var buildingsDictionary : [String:[Building]]
    private let buildingFileName : String = "buildings"
    private let favoriteFileName : String = "favorites"
    private let allKeys : [String]
    var buildingArchivePath : String
    var favoriteArchivePath : String
    
    private var favoriteBuildings = [Building]()
    private var userPlottedPins = [Building]()
    
    init() {
        let fileManager = NSFileManager.defaultManager()
        let URLS = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let URL = URLS[0]
        buildingArchivePath = URL.URLByAppendingPathComponent(buildingFileName).path!
        favoriteArchivePath = URL.URLByAppendingPathComponent(favoriteFileName).path!
        
        var _buildingsDictionary = [String:[Building]]()
        if fileManager.fileExistsAtPath(buildingArchivePath) {
            buildingsDictionary = NSKeyedUnarchiver.unarchiveObjectWithFile(buildingArchivePath) as! [String:[Building]]
        } else {
            let path = NSBundle.mainBundle().pathForResource(buildingFileName, ofType: "plist")
            let data = NSArray(contentsOfFile: path!) as! [[String:AnyObject]]
            
            for dictionary in data {
            
                let imageName = dictionary["photo"] as! String
                let image : UIImage
                if imageName != "" {
                    image = UIImage(named: "\(imageName).jpg")!
                } else {
                    image = UIImage(named: "NoImageAvailable.png")!
                }
                
                let building = Building(title: dictionary["name"] as! String, latitude: dictionary["latitude"] as! CLLocationDegrees, longitude: dictionary["longitude"] as! CLLocationDegrees, yearConstructed: dictionary["year_constructed"] as! Int, image: image, favorite: false, subtitle: "")
                building.image = image
                
                let firstLetter = building.title!.firstLetter()!
                if let _ = _buildingsDictionary[firstLetter] {
                    _buildingsDictionary[firstLetter]!.append(building)
                } else {
                    _buildingsDictionary[firstLetter] = [building]
                }
            }
            
            buildingsDictionary = _buildingsDictionary
        }
        
        if fileManager.fileExistsAtPath(favoriteArchivePath) {
            favoriteBuildings = NSKeyedUnarchiver.unarchiveObjectWithFile(favoriteArchivePath) as! [Building]
        }
        let keys = Array(buildingsDictionary.keys)
        allKeys = keys.sort()
        saveArchive()
    }
    
    func saveArchive(){
        NSKeyedArchiver.archiveRootObject(buildingsDictionary, toFile: buildingArchivePath)
    }
    
    func saveFavoriteArchive() {
        NSKeyedArchiver.archiveRootObject(favoriteBuildings, toFile: favoriteArchivePath)
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
        buildings.sortInPlace { ($0.title < $1.title)}
        return buildings[indexPath.row]
    }
    
    func indexTitles() -> [String] {
        return allKeys
    }
    
    func isFavoriteBuildingAtIndexPath(indexPath: NSIndexPath) -> Bool {
        let buildings : [Building] = buildingsInSection(indexPath.section)
        return buildings[indexPath.row].isFavorite
    }
    
    func toggleIsFavoriteBuildingAtIndexPath(indexPath: NSIndexPath, building: Building) {
        let letter = letterForSection(indexPath.section)
        let buildings = buildingsDictionary[letter]
        
        var loopCounter = 0
        for aBuilding in buildings! {
            if aBuilding.title == building.title {
                break
            }
            loopCounter += 1
        }
        
        buildingsDictionary[letter]![loopCounter].isFavorite = !buildingsDictionary[letter]![loopCounter].isFavorite
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
        saveFavoriteArchive()
    }
    
    func updateImageForBuilding(image : UIImage, building: Building){
        let firstletter = building.title?.firstLetter()
        let buildings = buildingsDictionary[firstletter!]
        var loopCounter = 0
        for aBuilding in buildings! {
            if aBuilding.title == building.title {
                break
            }
            loopCounter += 1
        }
        buildingsDictionary[firstletter!]![loopCounter].image = image
        saveArchive()
    }
    
    func yearConstructedForBuildingWithTitle(title : String) -> Int{
        let firstLetter = title.firstLetter()!
        let buildings = buildingsDictionary[firstLetter]!
        for aBuilding in buildings {
            if aBuilding.title == title {
                return aBuilding.yearConstructed
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
        saveFavoriteArchive()
    }
    
}










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
    //private let buildingsArray : [Building]
    private var buildingsDictionary : [String:[Building]]
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
        var _buildingsDictionary = [String:[Building]]()
        if fileManager.fileExistsAtPath(archivePath) {
            buildingsDictionary = NSKeyedUnarchiver.unarchiveObjectWithFile(archivePath) as! [String:[Building]]
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
                building.image = image
                _buildings.append(building)
                
                let firstLetter = building.title!.firstLetter()!
                if let _ = _buildingsDictionary[firstLetter] {
                    _buildingsDictionary[firstLetter]!.append(building)
                } else {
                    _buildingsDictionary[firstLetter] = [building]
                }
            }
            //_buildings.sortInPlace{($0.title < $1.title)}
            //buildingsArray = _buildings
            
            buildingsDictionary = _buildingsDictionary
        }
        
        
        
//        for building in buildingsArray {
//            let firstLetter = building.title!.firstLetter()!
//            if let _ = _buildingsDictionary[firstLetter] {
//                _buildingsDictionary[firstLetter]!.append(building)
//            } else {
//                _buildingsDictionary[firstLetter] = [building]
//            }
//        }
        
        
        
        let keys = Array(buildingsDictionary.keys)
        allKeys = keys.sort()
        saveArchive()
    }
    
    func saveArchive(){
        NSKeyedArchiver.archiveRootObject(buildingsDictionary, toFile: archivePath)
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
    
    func toggleIsFavoriteBuildingAtIndexPath(indexPath: NSIndexPath) {
        let buildings : [Building] = buildingsInSection(indexPath.section)
        buildings[indexPath.row].isFavorite = !buildings[indexPath.row].isFavorite
        //let letter = letterForSection(indexPath.section)
        //buildingsDictionary[letter]![indexPath.row].isFavorite = !buildingsDictionary[letter]![indexPath.row].isFavorite
        saveArchive()
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
    
    func updateImageForBuilding(image : UIImage, building: Building){
//        for building in buildingsArray {
//            if building.title == title {
//                building.image = image
//            }
//        }
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
        //building.image = image
        saveArchive()
    }
    
    func yearConstructedForBuildingWithTitle(title : String) -> Int{
//        for building in buildingsArray{
//            if building.title == title {
//                return building.yearConstructed
//            }
//        }
        return 2000
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










//
//  Model.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 10/20/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import Foundation
import MapKit

class Building : NSObject, MKAnnotation {
    var title : String?
    var subtitle : String?
    var coordinate : CLLocationCoordinate2D
    var isFavorite : Bool
    var yearConstructed : Int
    var image : UIImage
    
    init (title: String, coordinate: CLLocationCoordinate2D, subtitle:String){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        isFavorite = false
        yearConstructed = 0
        image = UIImage(named: "NoImageAvailable.png")!
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }

}

class Model {
    
    static let sharedInstance = Model()
    private let buildingsArray : [Building]
    private let buildingsDictionary : [String:[Building]]
    private let plistName : String = "buildings"
    private let allKeys : [String]
    
    private var favoriteBuildings = [Building]()
    private var userPlottedPins = [Building]()
    
    init() {
        let path = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
        let data = NSArray(contentsOfFile: path!) as! [[String:AnyObject]]
        
        var _buildings = [Building]()
        var _buildingsDictionary = [String:[Building]]()
        
        for dictionary in data {
            let building = Building(title: dictionary["name"] as! String, coordinate: CLLocationCoordinate2D(latitude: dictionary["latitude"] as! CLLocationDegrees, longitude: dictionary["longitude"] as! CLLocationDegrees), subtitle: "")
            let image = dictionary["photo"] as! String
            if image != "" {
                building.image = UIImage(named: "\(image).jpg")!
            }
            building.yearConstructed = dictionary["year_constructed"] as! Int
                    
            _buildings.append(building)
            
            let firstLetter = building.title!.firstLetter()!
            if let _ = _buildingsDictionary[firstLetter] {
                _buildingsDictionary[firstLetter]!.append(building)
            } else {
                _buildingsDictionary[firstLetter] = [building]
            }
        }
        
        for dictionary in _buildingsDictionary {
            dictionary
        }
        
        buildingsArray = _buildings
        buildingsDictionary = _buildingsDictionary
        let keys = Array(buildingsDictionary.keys)
        allKeys = keys.sort()
    }
    
    func placesToPlot() -> [Building] {
        return buildingsArray
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










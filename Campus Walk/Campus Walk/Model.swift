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
    
    //var buildingCode : Int
    //var yearConstructed : Int
    //var latitude : Float
    //var longitude : Float
    //var imageName : String
    
    //title: String, coordinate: CLLocationCoordinate2D, photoName:String, subtitle:String, category:BuildingCategory
    
    init (title: String, coordinate: CLLocationCoordinate2D, subtitle:String){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        isFavorite = false
        //title = ""
        //subtitle = ""
        //buildingCode = 0
        //yearConstructed = 0
        //latitude = 0.0
        //longitude = 0.0
        //imageName = ""
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
    
    init() {
        let path = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
        let data = NSArray(contentsOfFile: path!) as! [[String:AnyObject]]
        
        var _buildings = [Building]()
        var _buildingsDictionary = [String:[Building]]()
        
        for dictionary in data {
            let building = Building(title: dictionary["name"] as! String, coordinate: CLLocationCoordinate2D(latitude: dictionary["latitude"] as! CLLocationDegrees, longitude: dictionary["longitude"] as! CLLocationDegrees), subtitle: "")
            //building.title = dictionary["name"] as! String
            //building.buildingCode = dictionary["opp_bldg_code"] as! Int
            //building.yearConstructed = dictionary["year_constructed"] as! Int
            //building.latitude = dictionary["latitude"] as! Float
            //building.longitude = dictionary["longitude"] as! Float
            //let image = dictionary["photo"] as! String
            //building.imageName = "\(image).jpg"
            
            _buildings.append(building)
            
            let firstLetter = building.title!.firstLetter()!
            if let _ = _buildingsDictionary[firstLetter] {
                _buildingsDictionary[firstLetter]!.append(building)
            } else {
                _buildingsDictionary[firstLetter] = [building]
            }
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
        return buildingsDictionary[letterInSection]!
    }
    
    func numberOfBuildingsInSection(section: Int) -> Int{
        let buildings : [Building] = buildingsInSection(section)
        return buildings.count
    }
    
    func buildingAtIndexPath(indexPath : NSIndexPath) -> Building{
        let buildings : [Building] = buildingsInSection(indexPath.section)
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

}










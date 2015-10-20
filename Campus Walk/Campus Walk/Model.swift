//
//  Model.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 10/20/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import Foundation
import MapKit

class Building {
    var name : String
    //var buildingCode : Int
    //var yearConstructed : Int
    var latitude : Float
    var longitude : Float
    //var imageName : String
    
    init (){
        name = ""
        //buildingCode = 0
        //yearConstructed = 0
        latitude = 0.0
        longitude = 0.0
        //imageName = ""
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
            let building = Building()
            building.name = dictionary["name"] as! String
            //building.buildingCode = dictionary["opp_bldg_code"] as! Int
            //building.yearConstructed = dictionary["year_constructed"] as! Int
            building.latitude = dictionary["latitude"] as! Float
            building.longitude = dictionary["longitude"] as! Float
            //let image = dictionary["photo"] as! String
            //building.imageName = "\(image).jpg"
            
            _buildings.append(building)
            
            let firstLetter = building.name.firstLetter()!
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
    
   
}










//
//  Model.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 9/27/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import Foundation
import UIKit

class Model {
    var parksNSArray : NSArray = NSArray()
    var parksArray = [Park]()
    
    
    let numParks = 8
    
    class Park {
        var parkName : String
        //get rid of this
        var parkNumber : Int
        var images = [Photo]()
        
        init() {
            parkName = ""
            parkNumber = 0
        }
        
    }
    
    class Photo {
        var imageName : String
        var caption : String
        init() {
            imageName = ""
            caption = ""
        }
    }
    
    init() {
        extractParkInformation()
    }
    
    func generateParksArray() {
        for var i = 0; i < numParks; i++ {
            let tempPark = Park()
            tempPark.parkNumber = i
            parksArray.append(tempPark)
        }
    }
    
    func initializeParkPhotoPList(){
        if let parksBundlePath = NSBundle.mainBundle().pathForResource("Photos", ofType: ".plist") {
            parksNSArray = NSArray(contentsOfFile: parksBundlePath)!
        }
    }
    
    func generateParkDictionary(parkNum : Int) -> AnyObject {
        let parkDictionary = parksNSArray[parkNum]
        return parkDictionary
    }
    
    func extractParkInformation() {
        generateParksArray()
        initializeParkPhotoPList()
        for park in parksArray {
            let currentDictionary = generateParkDictionary(park.parkNumber)
            parksArray[park.parkNumber].parkName = currentDictionary["name"] as! String
        
            let photosNSArray = currentDictionary["photos"] as! NSMutableArray
            for var i = 0; i < photosNSArray.count; i++ {
                let tempPhoto = Photo()
                let currentPhoto = photosNSArray[i] as! [String : String]
                tempPhoto.imageName = currentPhoto["imageName"]!
                tempPhoto.caption = currentPhoto["caption"]!
                park.images.append(tempPhoto)
            }

        }
    }
 }






























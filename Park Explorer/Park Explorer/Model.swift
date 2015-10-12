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
    static let sharedInstance = Model()
    
    private var parksNSArray : NSArray = NSArray()
    private var instructionImages = [String]()
    private var parksArray = [Park]()
    
    let numParks = 8
    let numWalkThroughPages = 3
    
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
    
//    class InstructionPage {
//        //var index : Int
//        //var buttonTitle : String
//        var imageName : String
//        init(){
//            //index = 0
//            //buttonTitle = "Next"
//            imageName = "PageInstruction1.png"
//        }
//    }
    
    init() {
        extractParkInformation()
        configureInstructions()
    }
    
    func numberOfWalkThroughPages() -> Int{
        return numWalkThroughPages
    }
    
    func parkArray() -> [Park] {
        return parksArray
    }
    
    func instructionPageArray() -> [String]{
        return instructionImages
    }
    
    func pageInstructionImageAtIndex(index:Int) -> String{
        return instructionImages[index]
    }
//    func pageInstructionButtonTitleAtIndex(index:Int) -> String{
//        return instructionsArray[index].buttonTitle
//    }
    
    func numberOfParks() -> Int{
        return numParks
    }
    
    func imageNameForPark(parkNumber : Int, atIndex : Int ) -> String{
        return parksArray[parkNumber].images[atIndex].imageName
    }
    
    func imageCountForPark(parkNumber : Int) -> Int{
        return parksArray[parkNumber].images.count
    }
    
    func imageCaptionAtIndexPath(indexPath : NSIndexPath) -> String{
        return imageAtIndexPath(indexPath).caption
    }
    
    func imageNameAtIndexPath(indexPath : NSIndexPath) -> String {
        return imageAtIndexPath(indexPath).imageName
    }
    
    func parkNameForSection(section: Int) -> String{
        return parksArray[section].parkName
    }
    
    private func imageAtIndexPath(indexPath : NSIndexPath) -> Photo {
        return parksArray[indexPath.section].images[indexPath.row]
    }
    
    func parkAtIndexPath() -> Int{
        return 0
    }
    
    func configureInstructions(){
        for i in 0 ..< numWalkThroughPages {
            //let tempInstructionPage = InstructionPage()
            //tempInstructionPage.index = i
            let tempString = "PageInstruction\(i + 1).png"
            
//            if i == numWalkThroughPages - 1 {
//                tempInstructionPage.buttonTitle = "Continue to Parks!"
//            } else {
//                tempInstructionPage.buttonTitle = "Next"
//            }
            instructionImages.append(tempString)
        }
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






























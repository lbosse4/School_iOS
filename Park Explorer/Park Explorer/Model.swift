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
    var photosNSArray : NSArray = NSArray()
    var parksArray = [Park]()
    
    let numParks = 8
    
    class Park {
        var parkName : String
        var parkNumber : Int
        //array of images
        var images = [UIImageView]()
    
        init() {
            parkName = ""
            parkNumber = 0
        }
    
    }
    
    func initializeParkPhotoPList(){
        if let parksBundlePath = NSBundle.mainBundle().pathForResource("Photos", ofType: ".plist") {
            parksNSArray = NSArray(contentsOfFile: parksBundlePath)!
        }
    }
    
    func generateParkDictionary(parkNum : Int) -> [String : String] {
        let parkNameDictionary = parksNSArray[parkNum] as! [String : String]
        parksArray[parkNum].parkName = parkNameDictionary["name"]!
        let parkPhotoDictionary = photosNSArray[parkNum] as! [String : String]
        return parkPhotoDictionary
    }
    

    func generateParks () {
        
        for park in parksArray {
            
        }
    }
    
    /*
    func populatePiecesWithCurrentAnswers (currentDictionary : [String : [String : Int]]) {
        for piece in pentominoesArray {
    
            let letterDictionary = currentDictionary["\(piece.letter)"]!
    
            let xcoord = letterDictionary["x"]
            let ycoord = letterDictionary["y"]
            let numRotations = letterDictionary["rotations"]
            let numFlips = letterDictionary["flips"]
    
            piece.solutionX = Double(xcoord!)
            piece.solutionY = Double(ycoord!)
            piece.numRotationsSolution = numRotations!
            piece.numFlipsSolution = numFlips!
        }
    
    }
    */
    /*
    func extractBoardSolutions(boardNumber : Int){
        if boardNumber != 0 {
            initializeSolutionPList()
            let currentDictionary = generateBoardDictionary(currentBoardNumber - 1)
            populatePiecesWithCurrentAnswers(currentDictionary)
        }
    }*/
    
    func extractParkInformation() {
        initializeParkPhotoPList()
        for park in parksArray {
            let currentPhotoDictionary = generateParkDictionary(<#parkNum: Int#>)
        }
    }
    
}






























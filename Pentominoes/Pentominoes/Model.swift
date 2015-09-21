//
//  Model.swift
//  Pentominoes
//
//  Created by Lauren Bosse on 9/15/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import Foundation

import UIKit

class Model {
    
    let numBoards = 6
    let numPentominoesPieces = 12
    let landscapeModeX = 170.0
    let portraitModeX = 191.0
    let newPentominoLineBound = 4
    let rotationDuration = 0.3
    let numBoardButtons = 6
    
    var currentBoardNumber = 0
    var pentominoPaddingX : Double = 191.0
    var pentominoPaddingY : Double = 120.0
    
    var solutionsArray : NSArray = NSArray()
    
    let tileLettersArray = ["F", "I", "L", "N", "P", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var pentominoesArray = [pentominoesPiece]()
    
    class pentominoesPiece {
        var image : UIImage
        var numFlips : Int
        var numRotations : Int
        var initialX : Double
        var initialY : Double
        var width : Int
        var height : Int
        var letter : Character
        var solutionX : Double
        var solutionY : Double
        var numRotationsSolution : Int
        var numFlipsSolution : Int
        
        init() {
            image = UIImage(named: "tileF.png")!
            numFlips = 0
            numRotations = 0
            initialX = 0
            initialY = 0
            width = 0
            height = 0
            letter = "F"
            solutionX = 0
            solutionY = 0
            numRotationsSolution = 0
            numFlipsSolution = 0
        }
        
    }
    
    func generateBoardImageName(sender: AnyObject) -> String {
        let currentBoardTagPressed = sender.tag
        let currentBoardImageName = "Board\(currentBoardTagPressed).png"
        return currentBoardImageName
    }
    
    func generatePentominoesPieces() {
        var tempXCoordinate = 0.0 - pentominoPaddingX
        var tempYCoordinate = 0.0
        for i in 0..<numPentominoesPieces {
            let tempPentominoesPiece = pentominoesPiece()
            
            if let tempPentominoesImage = UIImage(named: "tile\(tileLettersArray[i]).png"){
//                
//                if tempXCoordinate + pentominoPaddingX > containerWidth {
//                    tempYCoordinate += pentominoPaddingY
//                    tempXCoordinate = 0
//                }else{
//                    tempXCoordinate += pentominoPaddingX
//                }
//                
                tempPentominoesPiece.image = tempPentominoesImage
//                tempPentominoesPiece.initialX = tempXCoordinate
//                tempPentominoesPiece.initialY = tempYCoordinate
                tempPentominoesPiece.letter = Character(tileLettersArray[i])
                
                pentominoesArray.append(tempPentominoesPiece)
            }
        }
        
        
        
    }
    
    func initializeSolutionPList(){
        if let solutionsBundlePath = NSBundle.mainBundle().pathForResource("Solutions", ofType: ".plist") {
            solutionsArray = NSArray(contentsOfFile: solutionsBundlePath)!
        }
    }
    func getBoardDictionary(boardNum:Int) -> [String : [String : Int]] {
        let boardDictionary = solutionsArray[boardNum] as! [String : [String : Int]]
        return boardDictionary
    }
    
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
    
    func extractBoardSolutions(boardNumber : Int){
        if boardNumber != 0 {
            initializeSolutionPList()
            let currentDictionary = getBoardDictionary(currentBoardNumber - 1)
            populatePiecesWithCurrentAnswers(currentDictionary)
        }
    }
    
    func generatePentominoesCoordinates (inout piece : pentominoesPiece, inout x: Double, inout y: Double, containerWidth: Double) {
        //var tempXCoordinate = x
        //var tempYCoordinate = y
        
        if x + pentominoPaddingX > containerWidth {
            y =  y + pentominoPaddingY
            x = 0.0
        }else{
            x =  x + pentominoPaddingX
        }
        
        piece.initialX = x
        piece.initialY = y
    }
    
}














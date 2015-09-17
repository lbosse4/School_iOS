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
    let pentominoPaddingX : CGFloat = 191
    let pentominoPaddingY : CGFloat = 105
    let newPentominoLineBound = 4
    let ninetyDegrees = (CGFloat(M_PI)) / 2.0
    let rotationDuration = 2.0
    
    var pentominoPiecesHaveBeenInitialized = false
    var currentBoardNumber = 0
    
    var solutionsArray = NSArray()
    var pentominoImageViews = [UIImageView]()
    
    let tileLettersArray = ["F", "I", "L", "N", "P", "T", "U", "V", "W", "X", "Y", "Z"]

    var pentominoesArray = [pentominoesPiece]()
    
    class pentominoesPiece {
        var image : UIImage
        var numFlips : Int
        var numRotations : Int
        var initialX : CGFloat
        var initialY : CGFloat
        var width : CGFloat
        var height : CGFloat
        var letter : Character
        var solutionX : CGFloat
        var solutionY : CGFloat
        var numberOfRotationsSolution : Int
        var numberOfFlipsSolution : Int
        
        init() {
            image = UIImage(named: "tileF.png")!
            numFlips = 0
            numRotations = 0
            initialX = 0.0
            initialY = 0.0
            width = 0.0
            height = 0.0
            letter = "F"
            solutionX = 0.0
            solutionY = 0.0
            numberOfRotationsSolution = 0
            numberOfFlipsSolution = 0
        }
        // use these to orient the piece
        func rotate() {
            
        }
        
        func flip () {
            
        }
    }
    
    func generateBoardImageName(sender: AnyObject) -> String {
        let currentBoardTagPressed = sender.tag
        let currentBoardImageName = "Board\(currentBoardTagPressed).png"
        return currentBoardImageName
    }
    
    func generatePentominoesPieces(containerSize : CGSize) {
        var tempXCoordinate : CGFloat = 0.0 - pentominoPaddingX
        var tempYCoordinate : CGFloat = 0.0
        for i in 0...numPentominoesPieces - 1 {
            let tempPentominoesPiece = pentominoesPiece()
            
            if let tempPentominoesImage = UIImage(named: "tile\(tileLettersArray[i]).png"){
                
                if tempXCoordinate + pentominoPaddingX > containerSize.width {
                    tempYCoordinate += pentominoPaddingY
                    tempXCoordinate = 0.0
                }else{
                    tempXCoordinate += pentominoPaddingX
                }
                
                tempPentominoesPiece.image = tempPentominoesImage
                tempPentominoesPiece.initialX = tempXCoordinate
                tempPentominoesPiece.initialY = tempYCoordinate
                tempPentominoesPiece.letter = Character(tileLettersArray[i])
                
                
                
                pentominoesArray.append(tempPentominoesPiece)
            }
            
            
            
        
        }
        
        
        
    }
    
    ////////////////////////////////////////
    //*
    //*
    //*
    //*         MOVE TO VIEW CONTROLLER
    //*
    //*
    //*
    //*
    func setInitialPieces(piece : pentominoesPiece) -> UIImageView{
        let myImage = piece.image
        let imageView = UIImageView(image: myImage)
        
        let pieceBoundSize = imageView.bounds.size
        
        imageView.frame = CGRect(x: piece.initialX, y: piece.initialY, width: pieceBoundSize.width, height: pieceBoundSize.height)
        
        pentominoImageViews.append(imageView)
        return imageView
        
    }
    
    func initializeSolutionPList(){
        if let solutionsBundlePath = NSBundle.mainBundle().pathForResource("Solutions", ofType: ".plist") {
        solutionsArray = NSArray(contentsOfFile: solutionsBundlePath)!
        }
    }
    func getBoardDictionary(boardNum:Int) -> NSDictionary {
        let boardDictionary = NSDictionary(objectsAndKeys: solutionsArray[boardNum])
        return boardDictionary
    }
    
    func populatePiecesWithCurrentAnswers (currentDictionary : NSDictionary) {
        for piece in pentominoesArray {
            
            if let xSolution = currentDictionary["x"] as? NSNumber{
                piece.solutionX = CGFloat(xSolution.floatValue)
            }
            if let ySolution = currentDictionary["y"] as? NSNumber{
                piece.solutionY = CGFloat(ySolution.floatValue)
            }
            if let rotationsSolution = currentDictionary["rotations"] as? NSNumber{
                piece.numRotations = rotationsSolution.integerValue
            }
            if let flipsSolution = currentDictionary["flips"] as? NSNumber {
                piece.numFlips = flipsSolution.integerValue
            }
        }
    }
    
    func solvePuzzle(boardNumber : Int){
        initializeSolutionPList()
        let currentDictionary = getBoardDictionary(currentBoardNumber)
        populatePiecesWithCurrentAnswers(currentDictionary)
    }
    
}














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
    
    let tileLettersArray = ["F", "I", "L", "N", "P", "T", "U", "V", "W", "X", "Y", "Z"]
    
    class pentominoesPiece {
        var image : UIImage
        var numFlips : Int
        var numRotations : Int
        var initialX : CGFloat
        var initialY : CGFloat
        
        init() {
            image = UIImage(named: "tileF.png")!
            numFlips = 0
            numRotations = 0
            initialX = 0.0
            initialY = 0.0
        }
    }
    
    //var pentominoesArray : pentominoesPiece
    
    init () {
        //pentominoesArray
    }
    
    func generateBoardImageName(sender: AnyObject) -> String {
        let currentBoardTagPressed = sender.tag
        let currentBoardImageName = "Board\(currentBoardTagPressed).png"
        return currentBoardImageName
    }
    
    func generatePentominoesPiece(arrayIndex: Int) -> pentominoesPiece {
        let tempPentominoesPiece = pentominoesPiece()
        let tempPentominoesImage = UIImage(named: "tile\(tileLettersArray[arrayIndex]).png")
        tempPentominoesPiece.image = tempPentominoesImage!
        return tempPentominoesPiece
    }
    
}
//
//  ViewController.swift
//  Pentominoes
//
//  Created by Lauren Bosse on 9/13/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ViewController : UIViewController {

    @IBOutlet weak var boardImageView: UIImageView!
    @IBOutlet weak var petominoesContainerView: UIView!
    
    let model = Model()
    
    let ninetyDegrees = (CGFloat(M_PI)) / 2.0
    let gridTileConversion : CGFloat = 30.0
    let isOdd = 1
    let isEven = 0
    
    var imageViews = [UIImageView]()
    var pentominoImageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        
        
        if !model.pentominoPiecesHaveBeenInitialized {
            let pentominoContainerSize = petominoesContainerView.bounds.size
            
            model.generatePentominoesPieces(pentominoContainerSize)
        
            for i in 0..<model.numPentominoesPieces {
                let myImage = model.pentominoesArray[i].image
                let imageView = UIImageView(image: myImage)
                
                let pieceBoundSize = imageView.bounds.size
                let width : CGFloat = pieceBoundSize.width
                let height : CGFloat = pieceBoundSize.height
                
                imageView.frame = CGRect(x: CGFloat(model.pentominoesArray[i].initialX), y: CGFloat(model.pentominoesArray[i].initialY), width: width, height: height)
                
                //imageView.frame = CGRect(x: model.pentominoesArray[i].initialX, y: model.pentominoesArray[i].initialY, width: width, height: height)
                
                pentominoImageViews.append(imageView)
                petominoesContainerView.addSubview(imageView)
            }
            
            model.pentominoPiecesHaveBeenInitialized = true
        }
    }
    
    @IBAction func boardButtonPressed(sender: AnyObject) {
        let currentBoardImageName = model.generateBoardImageName(sender)
        boardImageView.image = UIImage(named: currentBoardImageName)
        model.currentBoardNumber = sender.tag
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        for piece in model.pentominoesArray {
            /*
            if piece.numFlips != 0 {
                
            }
            
            if piece.numRotations != 0 {
                
            }*/
            
        }
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {
        model.extractBoardSolutions(model.currentBoardNumber)
        var loopCounter = 0
        for aView in pentominoImageViews {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                let pentominoContainerOrigin = self.petominoesContainerView.bounds.origin
                let pieceBounds = aView.bounds
                let pieceWidth = pieceBounds.width
                let pieceHeight = pieceBounds.height
                let gridOriginX = CGFloat(self.model.pentominoesArray[loopCounter].solutionX) * self.gridTileConversion
                let gridOriginY = CGFloat(self.model.pentominoesArray[loopCounter].solutionY) * self.gridTileConversion
                
                let newPieceOrigin = aView.convertPoint(pieceBounds.origin, fromView: self.boardImageView)
                
                let rect = CGRectMake(gridOriginX, gridOriginY, pieceWidth, pieceHeight)
                
                self.rotatePentominoView(aView, numRotations: self.model.pentominoesArray[loopCounter].numRotationsSolution)
                
                aView.frame = rect
                
                self.boardImageView.addSubview(aView)
                
                loopCounter += 1
            
            })
        
        }
    }
    
    func rotatePentominoView (view : UIImageView, numRotations : Int){
        if numRotations > 0{
            for i in 1 ... numRotations {
                UIView.animateWithDuration(model.rotationDuration, animations: {
                    view.transform = CGAffineTransformMakeRotation(self.ninetyDegrees)
                })
            }
        }
        
    }
    
    func checkNumberOfRotations (rotations : Int) -> Int{
        if rotations % 2 == 0 {
            return isEven
        }else{
            return isOdd
        }
    }

}











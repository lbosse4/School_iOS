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
    @IBOutlet weak var board0Button: UIButton!
    @IBOutlet weak var board1Button: UIButton!
    @IBOutlet weak var board2Button: UIButton!
    @IBOutlet weak var board3Button: UIButton!
    @IBOutlet weak var board4Button: UIButton!
    @IBOutlet weak var board5Button: UIButton!
    
    
    let model = Model()
    
    let ninetyDegrees = (CGFloat(M_PI)) / 2.0
    let gridTileConversion : CGFloat = 30.0
    let numRotationDifferences = 2
    let numPossibleRotations = 4
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
        var loopCounter = 0
        for aView in pentominoImageViews {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                let pieceBounds = aView.bounds
                let flipSolution = self.model.pentominoesArray[loopCounter].numFlipsSolution
                let rotationSolution = self.model.pentominoesArray[loopCounter].numRotationsSolution
                
                var pieceWidth : CGFloat = pieceBounds.width
                var pieceHeight : CGFloat = pieceBounds.height
                
                let originalOriginXCoordinate = CGFloat(self.model.pentominoesArray[loopCounter].initialX)
                let originalOriginYCoordinate = CGFloat(self.model.pentominoesArray[loopCounter].initialY)
                
                if self.model.pentominoesArray[loopCounter].numFlips != 0 {
                    self.flipPentominoView(aView, numFlips: flipSolution, numRotations: rotationSolution)
                }
                
                if self.model.pentominoesArray[loopCounter].numRotations != 0 {
                    self.rotatePentominoView(aView, numRotations: self.numPossibleRotations-rotationSolution, width: &pieceWidth, height: &pieceHeight)
                }
                
                let rect = CGRectMake(originalOriginXCoordinate, originalOriginYCoordinate, pieceWidth, pieceHeight)
                
                aView.frame = rect
                
                self.petominoesContainerView.addSubview(aView)
                
                loopCounter += 1
            })
            
            
            
        }
        
        board0Button.enabled = true
        board1Button.enabled = true
        board2Button.enabled = true
        board3Button.enabled = true
        board4Button.enabled = true
        board5Button.enabled = true
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {
        model.extractBoardSolutions(model.currentBoardNumber)
        var loopCounter = 0
        for aView in pentominoImageViews {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                let pieceBounds = aView.bounds
                let flipSolution = self.model.pentominoesArray[loopCounter].numFlipsSolution
                let rotationSolution = self.model.pentominoesArray[loopCounter].numRotationsSolution
                
                var pieceWidth : CGFloat = pieceBounds.width
                var pieceHeight : CGFloat = pieceBounds.height
                
                let gridOriginX = CGFloat(self.model.pentominoesArray[loopCounter].solutionX) * self.gridTileConversion
                let gridOriginY = CGFloat(self.model.pentominoesArray[loopCounter].solutionY) * self.gridTileConversion
                
                self.rotatePentominoView(aView, numRotations: rotationSolution, width: &pieceWidth, height: &pieceHeight)
                
                self.flipPentominoView(aView, numFlips: flipSolution, numRotations: rotationSolution)
                
                let rect = CGRectMake(gridOriginX, gridOriginY, pieceWidth, pieceHeight)
                
                aView.frame = rect
                
                self.boardImageView.addSubview(aView)
                
                loopCounter += 1
                
            })
            
        }
        
        board0Button.enabled = false
        board1Button.enabled = false
        board2Button.enabled = false
        board3Button.enabled = false
        board4Button.enabled = false
        board5Button.enabled = false
        
    }
    
    func rotatePentominoView (view : UIImageView, numRotations : Int, inout  width : CGFloat, inout height : CGFloat){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        if numRotations > 0{
            for i in 1 ... numRotations {
                UIView.animateWithDuration(model.rotationDuration, animations: {
                    view.transform = CGAffineTransformRotate(view.transform, self.ninetyDegrees)
                })
            }
        }
        if evenOrOdd == isOdd {
            swap(&width, &height)
        }
        
    }
    
    func flipPentominoView (view : UIImageView, numFlips : Int, numRotations : Int){
        let evenOrOdd = self.checkNumberOfRotations(numFlips)
        if numFlips > 0 {
            //if evenOrOdd == isEven {
                view.transform = CGAffineTransformScale(view.transform, -1.0, 1.0)
            //}else{
              //  view.transform = CGAffineTransformScale(view.transform, 1.0, -1.0)
            //}
        }
        
    }
    
    func checkNumberOfRotations (rotations : Int) -> Int{
        if rotations % numRotationDifferences == 0 {
            return isEven
        }else{
            return isOdd
        }
    }
    
}














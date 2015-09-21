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
    @IBOutlet weak var pentominoesContainerView: UIView!
    @IBOutlet weak var solveButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
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
    let isSolve = true
    let isReset = false
    let negativeTransformValue : CGFloat = -1.0
    let positiveTransformValue : CGFloat = 1.0
    let animationDuration = 0.3
    
    var boardButtons = [UIButton]()
    var pentominoImageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        solveButton.enabled = false
        resetButton.enabled = false
        
        boardButtons.append(board0Button)
        boardButtons.append(board1Button)
        boardButtons.append(board2Button)
        boardButtons.append(board3Button)
        boardButtons.append(board4Button)
        boardButtons.append(board5Button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        if !model.pentominoPiecesHaveBeenInitialized {
            
            let pentominoContainerSize = pentominoesContainerView.bounds.size
            
            model.generatePentominoesPieces(Double(pentominoContainerSize.width))
            
            for i in 0..<model.numPentominoesPieces {
                let myImage = model.pentominoesArray[i].image
                let imageView = UIImageView(image: myImage)
                
                let pieceBoundSize = imageView.bounds.size
                let width : CGFloat = pieceBoundSize.width
                let height : CGFloat = pieceBoundSize.height
                
                imageView.frame = CGRect(x: CGFloat(model.pentominoesArray[i].initialX), y: CGFloat(model.pentominoesArray[i].initialY), width: width, height: height)
                pentominoImageViews.append(imageView)
                pentominoesContainerView.addSubview(imageView)
                
            }
            
            model.pentominoPiecesHaveBeenInitialized = true
        } else {
            var tempXCoordinate = 0.0 - model.pentominoPaddingX
            var tempYCoordinate = 0.0
            for currentPiece in model.pentominoesArray {
                //implement. use this here and in generatePentominoesPieces
                model.generatePentominoesCoordinates(currentPiece, x: tempXCoordinate, y: tempYCoordinate, width: Double(pentominoesContainerView.bounds.width))
            }
        }
        
    }
    
    @IBAction func boardButtonPressed(sender: AnyObject) {
        let currentBoardImageName = model.generateBoardImageName(sender)
        boardImageView.image = UIImage(named: currentBoardImageName)
        model.currentBoardNumber = sender.tag
        if model.currentBoardNumber != 0 {
            solveButton.enabled = true
        } else {
            solveButton.enabled = false
        }
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        var loopCounter = 0
        for aView in pentominoImageViews {
            moveView(aView, toSuperview: pentominoesContainerView)
    
            let originalOriginXCoordinate = CGFloat(self.model.pentominoesArray[loopCounter].initialX)
            let originalOriginYCoordinate = CGFloat(self.model.pentominoesArray[loopCounter].initialY)
            let pieceBounds = aView.bounds
            let flipSolution = self.model.pentominoesArray[loopCounter].numFlipsSolution
            let rotationSolution = self.model.pentominoesArray[loopCounter].numRotationsSolution
            let rotationsNeededToReturn = self.numPossibleRotations - self.model.pentominoesArray[loopCounter].numRotations
            
            var pieceWidth : CGFloat = pieceBounds.width
            var pieceHeight : CGFloat = pieceBounds.height
            
            self.rotatePentominoView(aView, numRotations: rotationsNeededToReturn, width: &pieceWidth, height: &pieceHeight, isSolve: self.isReset)
            
            let evenOrOdd = self.checkNumberOfRotations(self.model.pentominoesArray[loopCounter].numRotations)
            if evenOrOdd == self.isOdd{
                self.flipPentominoView(aView, numFlips: flipSolution, numRotations: rotationSolution, x: positiveTransformValue, y: negativeTransformValue)
            }else {
                self.flipPentominoView(aView, numFlips: flipSolution, numRotations: rotationSolution, x: negativeTransformValue, y: positiveTransformValue)
            }
            
            self.model.pentominoesArray[loopCounter].numRotations = 0
            self.model.pentominoesArray[loopCounter].numFlips = 0
            
            let rect = CGRectMake(originalOriginXCoordinate, originalOriginYCoordinate, pieceWidth, pieceHeight)
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                aView.frame = rect
            })
            self.pentominoesContainerView.addSubview(aView)
                
            loopCounter += 1
        }
        
        updateBoardButtonEnabledStatus(true)
        resetButton.enabled = false
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {
        model.extractBoardSolutions(model.currentBoardNumber)
        var loopCounter = 0
        for aView in pentominoImageViews {
            moveView(aView, toSuperview: boardImageView)
            
            let gridOriginX = CGFloat(self.model.pentominoesArray[loopCounter].solutionX) * self.gridTileConversion
            let gridOriginY = CGFloat(self.model.pentominoesArray[loopCounter].solutionY) * self.gridTileConversion
            let pieceBounds = aView.bounds
            let flipSolution = self.model.pentominoesArray[loopCounter].numFlipsSolution
            let rotationSolution = self.model.pentominoesArray[loopCounter].numRotationsSolution
            
            var pieceWidth : CGFloat = pieceBounds.width
            var pieceHeight : CGFloat = pieceBounds.height
            
            self.rotatePentominoView(aView, numRotations: rotationSolution, width: &pieceWidth, height: &pieceHeight, isSolve: self.isSolve)
            self.model.pentominoesArray[loopCounter].numRotations += rotationSolution
            
            self.flipPentominoView(aView, numFlips: flipSolution, numRotations: rotationSolution, x: negativeTransformValue, y: positiveTransformValue)
            self.model.pentominoesArray[loopCounter].numFlips += flipSolution
            
            let rect = CGRectMake(gridOriginX, gridOriginY, pieceWidth, pieceHeight)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                aView.frame = rect
            })
            loopCounter += 1
            
        }
        
        updateBoardButtonEnabledStatus(false)
        solveButton.enabled = false
        resetButton.enabled = true
    }
    
    func updateBoardButtonEnabledStatus(status : Bool){
        for board in boardButtons {
            board.enabled = status
        }
    }
    
    func rotatePentominoView (view : UIImageView, numRotations : Int, inout  width : CGFloat, inout height : CGFloat, isSolve : Bool){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        if numRotations > 0{
            for i in 1 ... numRotations {
                UIView.animateWithDuration(model.rotationDuration, animations: {
                    view.transform = CGAffineTransformRotate(view.transform, self.ninetyDegrees)
                })
            }
        }
        if evenOrOdd == isOdd && isSolve{
            swap(&width, &height)
        }
    }
    
    func flipPentominoView (view : UIImageView, numFlips : Int, numRotations : Int, x : CGFloat, y : CGFloat){
        let evenOrOdd = self.checkNumberOfRotations(numFlips)
        if numFlips > 0 {
            UIView.animateWithDuration(model.rotationDuration, animations: { () -> Void in
                view.transform = CGAffineTransformScale(view.transform, x, y)
            })
        }
        
    }
    
    func checkNumberOfRotations (rotations : Int) -> Int{
        if rotations % numRotationDifferences == 0 {
            return isEven
        }else{
            return isOdd
        }
    }
    
    func moveView(view:UIView, toSuperview superView: UIView) {
        let newCenter = superView.convertPoint(view.center, fromView: view.superview)
        view.center = newCenter
        superView.addSubview(view)
    }
}














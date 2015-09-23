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
    let rotationDuration = 0.15
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
        
        model.generatePentominoesPieces()
        
        for i in 0..<model.numPentominoesPieces {
            let myImage = model.pentominoesArray[i].image
            let imageView = UIImageView(image: myImage)
            imageView.tag = i
            imageView.userInteractionEnabled = true
            
            pentominoImageViews.append(imageView)
            pentominoesContainerView.addSubview(imageView)
        }
        
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
        let pentominoContainerSize = pentominoesContainerView.bounds.size
        if view.bounds.width > view.bounds.height {
            model.pentominoPaddingX = model.landscapeModeX
        }
        else {
            model.pentominoPaddingX = model.portraitModeX
        }
        var loopCounter = 0
        var tempXCoordinate = 0.0 - model.pentominoPaddingX
        var tempYCoordinate = 0.0
        
        for aView in pentominoImageViews {
            var tempPiece = model.pentominoesArray[loopCounter]
            model.generatePentominoesCoordinates(&tempPiece, x: &tempXCoordinate, y: &tempYCoordinate, containerWidth: Double(pentominoContainerSize.width))
            
            model.pentominoesArray[loopCounter].initialX = tempXCoordinate
            model.pentominoesArray[loopCounter].initialY = tempYCoordinate
            
            let pieceBoundSize = aView.bounds.size
            let width : CGFloat = pieceBoundSize.width
            let height : CGFloat = pieceBoundSize.height
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                aView.frame.origin = CGPoint(x: CGFloat(self.model.pentominoesArray[loopCounter].initialX), y: CGFloat(self.model.pentominoesArray[loopCounter].initialY))
                //aView.frame = CGRect(x: CGFloat(tempXCoordinate), y: CGFloat(tempYCoordinate), width: width, height: height)
            })
            let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "singleTapRotate:")
            singleTapRecognizer.numberOfTapsRequired = 1
            //singleTapRecognizer.
            aView.addGestureRecognizer(singleTapRecognizer)
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTapFlip:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            aView.addGestureRecognizer(doubleTapRecognizer)
            
            singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
            
            let panRecognizer = UIPanGestureRecognizer(target: self, action: "panPentomino:")
            aView.addGestureRecognizer(panRecognizer)
            
            loopCounter += 1
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
            let rotationsNeededToReturn = self.model.numPossibleRotations - self.model.pentominoesArray[loopCounter].numRotations
            
            var pieceWidth : CGFloat = pieceBounds.width
            var pieceHeight : CGFloat = pieceBounds.height
            
            self.rotatePentominoView(aView, numRotations: rotationsNeededToReturn, width: &pieceWidth, height: &pieceHeight, isSolve: self.isReset, directionFactor: 1.0)
            
            //TAKE INTO ACCOUNT PREVIOUS FLIPS
            if flipSolution != 0 {
                let evenOrOdd = self.checkNumberOfRotations(self.model.pentominoesArray[loopCounter].numRotations)
                
                
                if evenOrOdd == self.isOdd{
                    self.flipPentominoView(aView, numRotations: rotationSolution, x: positiveTransformValue, y: negativeTransformValue)
                }else {
                    self.flipPentominoView(aView, numRotations: rotationSolution, x: self.negativeTransformValue, y: self.positiveTransformValue
                    )
                }
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
            
            //FIX THIS TO ACCOUNT FOR ANY PREVIOUS ROTATIONS - USE MOD
            if model.pentominoesArray[loopCounter].isUserFlipped {
                let evenOrOdd = self.checkNumberOfRotations(self.model.pentominoesArray[loopCounter].numRotations)
                
                
                if evenOrOdd == self.isOdd{
                    self.flipPentominoView(aView, numRotations: rotationSolution, x: positiveTransformValue, y: negativeTransformValue)
                }else {
                    self.flipPentominoView(aView, numRotations: rotationSolution, x: self.negativeTransformValue, y: self.positiveTransformValue
                    )
                }
            }
            let rotationsNeeded = model.calculateSolveRotations(model.pentominoesArray[loopCounter])
            let flipsNeeded = model.calculateSolveFlips(model.pentominoesArray[loopCounter])
            
            self.rotatePentominoView(aView, numRotations: rotationsNeeded, width: &pieceWidth, height: &pieceHeight, isSolve: self.isSolve, directionFactor: 1.0)
            self.model.pentominoesArray[loopCounter].numRotations += rotationsNeeded
            
            if flipsNeeded != 0 {
                self.flipPentominoView(aView, numRotations: rotationsNeeded, x: negativeTransformValue, y: positiveTransformValue)
                self.model.pentominoesArray[loopCounter].numFlips += flipsNeeded
            }
            
            //let rect = CGRectMake(gridOriginX, gridOriginY, pieceWidth, pieceHeight)
            let origin = CGPoint(x: gridOriginX, y: gridOriginY)
            
            UIView.animateWithDuration(rotationDuration, animations: { () -> Void in
                //aView.frame = rect
                aView.frame.origin = origin
            })
            loopCounter += 1
            
        }
        
        updateBoardButtonEnabledStatus(false)
        solveButton.enabled = false
        resetButton.enabled = true
    }
    
    func singleTapRotate (recognizer:UITapGestureRecognizer) {
        if let tappedImageView = recognizer.view as? UIImageView {
            var width = tappedImageView.bounds.width
            var height = tappedImageView.bounds.height
            let isUserFlipped = model.pentominoesArray[tappedImageView.tag].isUserFlipped
            
            if isUserFlipped {
                rotatePentominoView(tappedImageView, numRotations: 1, width: &width, height: &height, isSolve: isSolve, directionFactor: -1.0)
            }else {
                rotatePentominoView(tappedImageView, numRotations: 1, width: &width, height: &height, isSolve: self.isSolve, directionFactor: 1.0)
            }
            
            model.pentominoesArray[tappedImageView.tag].numRotations++
        }
        
    }

    func doubleTapFlip (recognizer:UITapGestureRecognizer) {
        if let tappedImageView = recognizer.view as? UIImageView {
            let evenOrOdd = self.checkNumberOfRotations(model.pentominoesArray[tappedImageView.tag].numRotations )
            if evenOrOdd == isOdd {
                flipPentominoView(tappedImageView, numRotations: model.pentominoesArray[tappedImageView.tag].numRotations, x: self.negativeTransformValue, y: self.positiveTransformValue)
            } else {
                flipPentominoView(tappedImageView, numRotations: model.pentominoesArray[tappedImageView.tag].numRotations, x: self.negativeTransformValue, y: self.positiveTransformValue)
            }
            
            model.pentominoesArray[tappedImageView.tag].numFlips++
            let numUserFlips = model.pentominoesArray[tappedImageView.tag].numUserFlips
            if numUserFlips % model.numPossibleFlips == 1{
                 model.pentominoesArray[tappedImageView.tag].isUserFlipped = true
            } else{
                model.pentominoesArray[tappedImageView.tag].isUserFlipped = false
            }
        }
        
    }
    
    func panPentomino (recognizer: UIPanGestureRecognizer){
        if let panningImageView = recognizer.view as? UIImageView {
            let point = recognizer.locationInView(pentominoesContainerView)
            panningImageView.frame.origin = point
            switch recognizer.state {
            case .Began:
                var origin = pentominoesContainerView.convertPoint(recognizer.locationInView(boardImageView), fromView: pentominoesContainerView)
                panningImageView.center = origin
                boardImageView.bringSubviewToFront(panningImageView)
            case .Changed:
                boardImageView.addSubview(panningImageView)
                //var origin = recognizer.locationInView(boardImageView)
                //moveView(panningImageView, toSuperview: boardImageView)
                var origin = pentominoesContainerView.convertPoint(recognizer.locationInView(boardImageView), fromView: pentominoesContainerView)
                panningImageView.center = origin
                boardImageView.bringSubviewToFront(panningImageView)

                return
            case .Ended:
                boardImageView.addSubview(panningImageView)
                //var origin = recognizer.locationInView(boardImageView)
                //moveView(panningImageView, toSuperview: boardImageView)
                var origin = pentominoesContainerView.convertPoint(recognizer.locationInView(boardImageView), fromView: pentominoesContainerView)
                //panningImageView.frame.origin = origin
                panningImageView.center = origin
                boardImageView.bringSubviewToFront(panningImageView)
                
                let currentLocation = recognizer.locationInView(boardImageView)
                
                if checkPanningViewBounds(currentLocation) {
                    //RESET PIECE
                }
                return
            case .Cancelled:
                //reset ImageView (panningImageView)
                pentominoesContainerView.addSubview(panningImageView)
                //RESET THE PIECE
                return
            default:
                break
            }
        }
        
    }
    
    func updateBoardButtonEnabledStatus(status : Bool){
        for board in boardButtons {
            board.enabled = status
        }
    }
    
    func rotatePentominoView (view : UIImageView, numRotations : Int,inout width : CGFloat, inout height : CGFloat, isSolve : Bool, directionFactor : CGFloat){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        if numRotations > 0{
            for i in 1 ... numRotations {
                UIView.animateWithDuration(rotationDuration, animations: {
                    view.transform = CGAffineTransformRotate(view.transform, self.ninetyDegrees * directionFactor)
                })
            }
        }
        if evenOrOdd == isOdd && isSolve{
            swap(&width, &height)
        }
    }
    
    func flipPentominoView (view : UIImageView, numRotations : Int, x: CGFloat, y: CGFloat){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        UIView.animateWithDuration(rotationDuration, animations: { () -> Void in
            view.transform = CGAffineTransformScale(view.transform, x, y)
        })
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
    
    func checkPanningViewBounds (currentLocation: CGPoint) -> Bool{
        return (currentLocation.x > boardImageView.bounds.width) || (currentLocation.x < 0) || (currentLocation.y > boardImageView.bounds.height) || (currentLocation.y < 0)
    }
}
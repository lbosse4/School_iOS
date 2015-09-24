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
            imageView.userInteractionEnabled = true
            imageView.letter = String(model.pentominoesArray[i].letter)
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

            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                aView.frame.origin = CGPoint(x: CGFloat(self.model.pentominoesArray[loopCounter].initialX), y: CGFloat(self.model.pentominoesArray[loopCounter].initialY))
            })
            
            let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "singleTapRotate:")
            singleTapRecognizer.numberOfTapsRequired = 1
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
            
            self.model.pentominoesArray[loopCounter].numRotations = 0
            self.model.pentominoesArray[loopCounter].numFlips = 0
            
            let origin = CGPoint(x: originalOriginXCoordinate, y: originalOriginYCoordinate)
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                aView.frame.origin = origin
                aView.transform = CGAffineTransformIdentity
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
            
            UIView.animateWithDuration(rotationDuration, animations: { () -> Void in
                aView.transform = CGAffineTransformIdentity
                
                self.rotatePentominoView(aView, numRotations: rotationSolution, width: &pieceWidth, height: &pieceHeight, isSolve: self.isSolve)
                
                if flipSolution != 0 {
                    self.weirdflipPentominoView(aView, numRotations: rotationSolution, x: self.negativeTransformValue, y: self.positiveTransformValue)
                }
                
                let origin = CGPoint(x: gridOriginX, y: gridOriginY)

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
            let index = findViewIndex(tappedImageView)
            var width = tappedImageView.bounds.width
            var height = tappedImageView.bounds.height
            let isUserFlipped = model.pentominoesArray[index].isUserFlipped
            
            UIView.animateWithDuration(rotationDuration, animations: { () -> Void in
                self.rotatePentominoView(tappedImageView, numRotations: 1, width: &width, height: &height, isSolve: self.isSolve)
            })
            model.pentominoesArray[index].numRotations++
        }
    }

    func doubleTapFlip (recognizer:UITapGestureRecognizer) {
        if let tappedImageView = recognizer.view as? UIImageView {
            let index = findViewIndex(tappedImageView)
            let evenOrOdd = self.checkNumberOfRotations(model.pentominoesArray[index].numRotations )
            if evenOrOdd == isOdd {
                flipPentominoView(tappedImageView, numRotations: model.pentominoesArray[index].numRotations, currentNumRotations: model.pentominoesArray[index].numRotations)
            } else {
                flipPentominoView(tappedImageView, numRotations: model.pentominoesArray[index].numRotations, currentNumRotations: model.pentominoesArray[index].numRotations)
            }
            
            model.pentominoesArray[index].numFlips++
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
    
    func weirdrotatePentominoView (view : UIImageView, numRotations : Int,inout width : CGFloat, inout height : CGFloat, isSolve : Bool, directionFactor : CGFloat){
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
    
    func weirdflipPentominoView (view : UIImageView, numRotations : Int, x: CGFloat, y: CGFloat){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        UIView.animateWithDuration(rotationDuration, animations: { () -> Void in
            view.transform = CGAffineTransformScale(view.transform, x, y)
        })
    }
    
    func rotatePentominoView (view : UIImageView, numRotations : Int,inout width : CGFloat, inout height : CGFloat, isSolve : Bool){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        if numRotations > 0{
            for i in 1 ... numRotations {
                //UIView.animateWithDuration(rotationDuration, animations: {
                    view.transform = CGAffineTransformRotate(view.transform, self.ninetyDegrees)
                //})
            }
        }
        if evenOrOdd == isOdd && isSolve{
            swap(&width, &height)
        }
    }
    
    func flipPentominoView (view : UIImageView, numRotations : Int, currentNumRotations: Int){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
            if evenOrOdd == self.isOdd {
                view.transform = CGAffineTransformScale(view.transform, self.positiveTransformValue , self.negativeTransformValue)
            }
            else {
                view.transform = CGAffineTransformScale(view.transform, self.negativeTransformValue , self.positiveTransformValue)
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
    
    func checkPanningViewBounds (currentLocation: CGPoint) -> Bool{
        return (currentLocation.x > boardImageView.bounds.width) || (currentLocation.x < 0) || (currentLocation.y > boardImageView.bounds.height) || (currentLocation.y < 0)
    }
    func findViewIndex(currentView :UIImageView) -> Int{
        var index = 0
        for i in 0..<model.numPentominoesPieces {
            
            if currentView.letter == String(model.pentominoesArray[i].letter){
                index = i
            }
        }
        return index
    }
}


extension UIView {
    var letter : String {
        get { return String(UnicodeScalar(tag))}
        set(newLetter){
            let s : NSString = newLetter
            tag = Int(s.characterAtIndex(0))
        }
    }
}
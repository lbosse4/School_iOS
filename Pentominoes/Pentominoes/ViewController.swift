//
//  ViewController.swift
//  Pentominoes
//
//  Created by Lauren Bosse on 9/13/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ViewController : UIViewController, HintDelegateProtocol, UIGestureRecognizerDelegate {

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
    @IBOutlet weak var hintButton: UIButton!
    
    
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
    let animationDuration = 0.2
    
    var boardButtons = [UIButton]()
    var pentominoImageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        solveButton.enabled = false
        resetButton.enabled = false
        hintButton.enabled = false
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
            //singleTapRecognizer.delegate = self
            aView.addGestureRecognizer(singleTapRecognizer)
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTapFlip:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            //doubleTapRecognizer.delegate = self
            aView.addGestureRecognizer(doubleTapRecognizer)
            
            singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
            
            let panRecognizer = UIPanGestureRecognizer(target: self, action: "panPentomino:")
            //panRecognizer.delegate = self
            aView.addGestureRecognizer(panRecognizer)
            
            loopCounter += 1
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "HintSegue":
            let hintViewController = segue.destinationViewController as! HintsViewController
            hintViewController.delegate = self
            hintViewController.configureWithBoardNumber(model.currentBoardNumber)
            hintViewController.configureWithHintNumber(model.hintCount)
            
            hintViewController.completionBlock = {() in self.dismissViewControllerAnimated(true, completion: nil)}
        default:
            assert(false, "Unhandled Segue in ViewController")
        }
    }
//    
//    //MARK: Gesture Delegate
//    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer {
//            let currentLocation = tapGestureRecognizer.locationInView(pentominoesContainerView)
//            if let imageView = tapGestureRecognizer.view as? UIImageView {
//                if !checkPentominoContainerBounds(currentLocation){
//                    //imageView.userInteractionEnabled = false
//                    tapGestureRecognizer.enabled = false
//                    //tapGestureRecognizer.
//                }
//                else {
//                    //imageView.userInteractionEnabled = true
//                    tapGestureRecognizer.enabled = true
//                }
//            }
//        }
////        else if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
////            if let imageView = tapGestureRecognizer.view as? UIImageView{
////                imageView.userInteractionEnabled = true
////            }
////        }
//        return true
//    }
    
    @IBAction func boardButtonPressed(sender: AnyObject) {
        let currentBoardImageName = model.generateBoardImageName(sender)
        boardImageView.image = UIImage(named: currentBoardImageName)
        
        if !(model.currentBoardNumber == sender.tag) {
            for aView in pentominoImageViews {
                let index = findViewIndex(aView)
                resetPentominoView(aView, index: index)
            }
            model.hintCount = 0
        }
        
        model.currentBoardNumber = sender.tag
        
        if model.currentBoardNumber != 0 {
            solveButton.enabled = true
            hintButton.enabled = true
        } else {
            solveButton.enabled = false
            hintButton.enabled = false
        }
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        for aView in pentominoImageViews {
            let index = findViewIndex(aView)
            resetPentominoView(aView, index: index)
        }
        
        updateBoardButtonEnabledStatus(true)
        resetButton.enabled = false
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {
        hintButton.enabled = false
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
                    self.flipPentominoView(aView, numRotations: rotationSolution, x: self.negativeTransformValue, y: self.positiveTransformValue)
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
    
    @IBAction func hintButtonPressed(sender: UIButton) {
        if model.hintCount <= model.numPentominoesPieces{
            model.hintCount++
        }
    }
    
    
    func singleTapRotate (recognizer:UITapGestureRecognizer) {
        if let tappedImageView = recognizer.view as? UIImageView {
            let currentLocation = recognizer.locationInView(boardImageView)
            if !checkPanningViewBounds(currentLocation){
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
    }

    func doubleTapFlip (recognizer:UITapGestureRecognizer) {
        if let tappedImageView = recognizer.view as? UIImageView {
            let currentLocation = recognizer.locationInView(boardImageView)
            if !checkPanningViewBounds(currentLocation){
                let index = findViewIndex(tappedImageView)
                let evenOrOdd = self.checkNumberOfRotations(model.pentominoesArray[index].numRotations )
                UIView.animateWithDuration(rotationDuration, animations: { () -> Void in
                    if evenOrOdd == self.isOdd {
                        self.flipPentominoView(
                            tappedImageView, numRotations: self.model.pentominoesArray[index].numRotations, x: self.positiveTransformValue, y: self.negativeTransformValue)
                    } else {
                        self.flipPentominoView(tappedImageView, numRotations: self.model.pentominoesArray[index].numRotations, x: self.negativeTransformValue, y: self.positiveTransformValue)
                    }
                })
                model.pentominoesArray[index].numFlips++
            }
        }
    }
    
    
    func panPentomino (recognizer: UIPanGestureRecognizer){
        if let panningImageView = recognizer.view as? UIImageView {
            let point = recognizer.locationInView(pentominoesContainerView)
            panningImageView.frame.origin = point
            switch recognizer.state {
            case .Began:
                boardImageView.addSubview(panningImageView)
                var origin = pentominoesContainerView.convertPoint(recognizer.locationInView(boardImageView), fromView: pentominoesContainerView)
                panningImageView.center = origin
                boardImageView.bringSubviewToFront(panningImageView)
            case .Changed:
                boardImageView.addSubview(panningImageView)
                var origin = pentominoesContainerView.convertPoint(recognizer.locationInView(boardImageView), fromView: pentominoesContainerView)
                panningImageView.center = origin
                boardImageView.bringSubviewToFront(panningImageView)

                return
            case .Ended:
                boardImageView.addSubview(panningImageView)
                var origin = pentominoesContainerView.convertPoint(recognizer.locationInView(boardImageView), fromView: pentominoesContainerView)
                panningImageView.center = origin
                boardImageView.bringSubviewToFront(panningImageView)
                
                let currentLocation = recognizer.locationInView(boardImageView)
                
                if checkPanningViewBounds(currentLocation) {
                    let index = findViewIndex(panningImageView)
                    resetPentominoView(panningImageView, index: index)
                }
                return
            case .Cancelled:
                let index = findViewIndex(panningImageView)
                resetPentominoView(panningImageView, index: index)
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
    
    func flipPentominoView (view : UIImageView, numRotations : Int, x: CGFloat, y: CGFloat){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        view.transform = CGAffineTransformScale(view.transform, x, y)
    }
    
    func rotatePentominoView (view : UIImageView, numRotations : Int,inout width : CGFloat, inout height : CGFloat, isSolve : Bool){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        if numRotations > 0{
            for i in 1 ... numRotations {
                view.transform = CGAffineTransformRotate(view.transform, self.ninetyDegrees)
            }
        }
        if evenOrOdd == isOdd && isSolve{
            swap(&width, &height)
        }
    }
    
    func resetPentominoView (aView : UIImageView, index: Int){
        moveView(aView, toSuperview: pentominoesContainerView)
        
        let originalOriginXCoordinate = CGFloat(self.model.pentominoesArray[index].initialX)
        let originalOriginYCoordinate = CGFloat(self.model.pentominoesArray[index].initialY)
        
        self.model.pentominoesArray[index].numRotations = 0
        self.model.pentominoesArray[index].numFlips = 0
        
        let origin = CGPoint(x: originalOriginXCoordinate, y: originalOriginYCoordinate)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            aView.frame.origin = origin
            aView.transform = CGAffineTransformIdentity
        })
        self.pentominoesContainerView.addSubview(aView)
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
    
    func checkPentominoContainerBounds(currentLocation: CGPoint) -> Bool{
        return (currentLocation.x > pentominoesContainerView.bounds.width) || (currentLocation.x < 0) || (currentLocation.y > pentominoesContainerView.bounds.height) || (currentLocation.y < 0)
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
    
    func dismissHints() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
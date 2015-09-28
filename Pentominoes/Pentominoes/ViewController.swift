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
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet var boardButtons: [UIButton]!
    
    
    let model = Model()
    
    let ninetyDegrees = (CGFloat(M_PI)) / 2.0
    let gridTileConversion : CGFloat = 30.0
    let gridTileConversionInt : Int = 30
    let numRotationDifferences = 2
    let numFlipDifferences = 2
    let numPossibleRotations = 4
    let singleTapNumRotations = 1
    let resizeFactor : CGFloat = 1.25
    let rotationDuration = 0.15
    let isOdd = 1
    let isEven = 0
    let isSolve = true
    let isReset = false
    let negativeTransformValue : CGFloat = -1.0
    let positiveTransformValue : CGFloat = 1.0
    let animationDuration = 0.2
    
    var pentominoImageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        solveButton.enabled = false
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
    
        var tempXCoordinate = 0.0 - model.pentominoPaddingX
        var tempYCoordinate = 0.0
        
        for aView in pentominoImageViews {
            let index = findViewIndex(aView)
            var tempPiece = model.pentominoesArray[index]
            model.generatePentominoesCoordinates(&tempPiece, x: &tempXCoordinate, y: &tempYCoordinate, containerWidth: Double(pentominoContainerSize.width))
            
            model.pentominoesArray[index].initialX = tempXCoordinate
            model.pentominoesArray[index].initialY = tempYCoordinate

            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                let boardCoordinates = aView.convertPoint(CGPoint(x: aView.frame.origin.x, y: aView.frame.origin.y), fromCoordinateSpace: self.boardImageView)
                if self.checkBoardViewBounds(boardCoordinates) {
                    aView.frame.origin = CGPoint(x: CGFloat(self.model.pentominoesArray[index].initialX), y: CGFloat(self.model.pentominoesArray[index].initialY))
                }
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
        } else {
            solveButton.enabled = false
        }
        checkHintandSolveButtonStatus()
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        checkHintandSolveButtonStatus()
        for aView in pentominoImageViews {
            let index = findViewIndex(aView)
            resetPentominoView(aView, index: index)
        }
        
        updateBoardButtonEnabledStatus(true)
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {
        hintButton.enabled = false
        model.extractBoardSolutions(model.currentBoardNumber)
        
        for aView in pentominoImageViews {
            let index = findViewIndex(aView)
            moveView(aView, toSuperview: boardImageView)
            
            let gridOriginX = CGFloat(self.model.pentominoesArray[index].solutionX) * self.gridTileConversion
            let gridOriginY = CGFloat(self.model.pentominoesArray[index].solutionY) * self.gridTileConversion
            let pieceBounds = aView.bounds
            let flipSolution = self.model.pentominoesArray[index].numFlipsSolution
            let rotationSolution = self.model.pentominoesArray[index].numRotationsSolution
            
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
            
        }
        model.hintCount = 0
        updateBoardButtonEnabledStatus(false)
        
        solveButton.enabled = false
    }
    
    @IBAction func hintButtonPressed(sender: UIButton) {
        if model.hintCount <= model.numPentominoesPieces{
            model.hintCount++
        }
    }
    
    func singleTapRotate (recognizer:UITapGestureRecognizer) {
        if let tappedImageView = recognizer.view as? UIImageView {
            let currentLocation = recognizer.locationInView(boardImageView)
            if !checkBoardViewBounds(currentLocation){
                let index = findViewIndex(tappedImageView)
                var width = tappedImageView.bounds.width
                var height = tappedImageView.bounds.height
                let evenOrOdd = self.checkNumberOfFlips(model.pentominoesArray[index].numFlips)
                UIView.animateWithDuration(rotationDuration, animations: { () -> Void in
                    if evenOrOdd == self.isOdd {
                        self.rotatePentominoViewCounterClockwise(tappedImageView, numRotations: self.singleTapNumRotations, width: &width, height: &height, isSolve: self.isSolve)
                    } else {
                        self.rotatePentominoView(tappedImageView, numRotations: self.singleTapNumRotations, width: &width, height: &height, isSolve: self.isSolve)
                    }
                    
                    let currentLocation = tappedImageView.frame.origin
                    
                    let snapOrigin : CGPoint = self.findSnapCoordinates(currentLocation);
                    tappedImageView.frame.origin = CGPoint(x: snapOrigin.x, y: snapOrigin.y)
                })
                
                model.pentominoesArray[index].numRotations++
            }
        }
    }

    func doubleTapFlip (recognizer:UITapGestureRecognizer) {
        if let tappedImageView = recognizer.view as? UIImageView {
            let currentLocation = recognizer.locationInView(boardImageView)
            if !checkBoardViewBounds(currentLocation){
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
            let index = findViewIndex(panningImageView)
            let point = recognizer.locationInView(pentominoesContainerView)
            panningImageView.frame.origin = point
            switch recognizer.state {
            case .Began:
                boardImageView.addSubview(panningImageView)
                let origin = pentominoesContainerView.convertPoint(recognizer.locationInView(boardImageView), fromView: pentominoesContainerView)
                let imageBounds = panningImageView.bounds
                let evenOrOdd = checkNumberOfRotations(model.pentominoesArray[index].numRotations)
                if evenOrOdd == isEven {
                    panningImageView.frame = CGRect(x: origin.x, y: origin.y, width: imageBounds.width * resizeFactor, height: imageBounds.height * resizeFactor)
                } else {
                    panningImageView.frame = CGRect(x: origin.x, y: origin.y, width: imageBounds.height * resizeFactor, height: imageBounds.width * resizeFactor)
                }
                boardImageView.bringSubviewToFront(panningImageView)
            case .Changed:
                boardImageView.addSubview(panningImageView)
                let origin = pentominoesContainerView.convertPoint(recognizer.locationInView(boardImageView), fromView: pentominoesContainerView)

                panningImageView.center = origin
                boardImageView.bringSubviewToFront(panningImageView)

                return
            case .Ended:
                let imageBounds = panningImageView.bounds
                
                boardImageView.bringSubviewToFront(panningImageView)
                boardImageView.addSubview(panningImageView)
                let origin = pentominoesContainerView.convertPoint(recognizer.locationInView(boardImageView), fromView: pentominoesContainerView)
                panningImageView.center = origin
                boardImageView.bringSubviewToFront(panningImageView)
                
                let currentLocation = panningImageView.frame.origin
                let evenOrOdd = checkNumberOfRotations(model.pentominoesArray[index].numRotations)
                if evenOrOdd == isEven {
                    panningImageView.frame = CGRect(x: origin.x, y: origin.y, width: imageBounds.width * (1/resizeFactor), height: imageBounds.height * (1/resizeFactor))
                } else {
                    panningImageView.frame = CGRect(x: origin.x, y: origin.y, width: imageBounds.height * (1/resizeFactor), height: imageBounds.width * (1/resizeFactor))
                }
                
                if checkBoardViewBounds(currentLocation) {
                    resetPentominoView(panningImageView, index: index)
                } else {
                    let snapOrigin : CGPoint = findSnapCoordinates(currentLocation);
                    boardImageView.addSubview(panningImageView)
                    //UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                        panningImageView.frame.origin = CGPoint(x: snapOrigin.x, y: snapOrigin.y)
                    //})
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
        view.transform = CGAffineTransformScale(view.transform, x, y)
    }
    
    func rotatePentominoView (view : UIImageView, numRotations : Int,inout width : CGFloat, inout height : CGFloat, isSolve : Bool){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        if numRotations > 0{
            for var i = 1; i < numRotations; i++ {
                view.transform = CGAffineTransformRotate(view.transform, self.ninetyDegrees)
            }
        }
        if evenOrOdd == isOdd && isSolve{
            swap(&width, &height)
        }
    }
    
    func rotatePentominoViewCounterClockwise (view : UIImageView, numRotations : Int,inout width : CGFloat, inout height : CGFloat, isSolve : Bool){
        let evenOrOdd = self.checkNumberOfRotations(numRotations)
        if numRotations > 0{
            for var i = 1; i < numRotations; i++ {
                view.transform = CGAffineTransformRotate(view.transform, self.ninetyDegrees * (-1.0))
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
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            aView.transform = CGAffineTransformIdentity
            let origin = CGPoint(x: originalOriginXCoordinate, y: originalOriginYCoordinate)
            aView.frame.origin = origin
            
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
    
    func checkNumberOfFlips (flips : Int) -> Int{
        if flips % numFlipDifferences == 0 {
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
    
    func checkBoardViewBounds (currentLocation: CGPoint) -> Bool{
        return (currentLocation.x > boardImageView.bounds.width) || (currentLocation.x < 0) || (currentLocation.y > boardImageView.bounds.height) || (currentLocation.y < 0)
    }
    
    func findSnapCoordinates(currentOrigin : CGPoint) -> CGPoint{
        var x : Int = Int(currentOrigin.x) / gridTileConversionInt
        var y : Int = Int(currentOrigin.y) / gridTileConversionInt
        let xRemainder = currentOrigin.x % gridTileConversion
        let yRemainder = currentOrigin.y % gridTileConversion

        if xRemainder > gridTileConversion/2 {
            x++
        }
        
        if yRemainder > gridTileConversion/2 {
            y++
        }
        
        let CGx = CGFloat(x) * gridTileConversion
        let CGy = CGFloat(y) * gridTileConversion
        
        return CGPoint(x: CGx, y: CGy)
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
    
    func checkHintandSolveButtonStatus (){
        if model.currentBoardNumber != 0 {
            hintButton.enabled = true
            solveButton.enabled = true
        } else {
            hintButton.enabled = false
            solveButton.enabled = false
        }
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
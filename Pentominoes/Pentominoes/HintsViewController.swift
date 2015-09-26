//
//  HintsViewController.swift
//  Pentominoes
//
//  Created by Lauren Bosse on 9/24/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import UIKit
protocol HintDelegateProtocol {
    func dismissHints()
}


class HintsViewController : UIViewController {

    var pentominoImageViews = [UIImageView]()
    var delegate : HintDelegateProtocol?
    var currentBoardNumber : Int = 0
    var numHints = 0
    var completionBlock : (() -> Void)?
    var solutionsArray : NSArray = NSArray()
    var pentominoesArray = [pentominoesPiece]()
    
    let negativeTransformValue : CGFloat = -1.0
    let positiveTransformValue : CGFloat = 1.0
    let initialOrigin = CGPoint(x: 0.0, y: 0.0)
    let numRotationDifferences = 2
    let isOdd = 1
    let isEven = 0
    let ninetyDegrees = (CGFloat(M_PI)) / 2.0
    let numPentominoesPieces = 12
    let gridTileConversion : CGFloat = 30.0
    let tileLettersArray = ["F", "I", "L", "N", "P", "T", "U", "V", "W", "X", "Y", "Z"]
    
    @IBOutlet weak var backgroudView: UIImageView!
    @IBOutlet weak var boardView: UIImageView!
    
    class pentominoesPiece {
        var image : UIImage
        var letter : Character
        var solutionX : Double
        var solutionY : Double
        var numRotationsSolution : Int
        var numFlipsSolution : Int
        
        init() {
            image = UIImage(named: "tileF.png")!
            letter = "F"
            solutionX = 0
            solutionY = 0
            numRotationsSolution = 0
            numFlipsSolution = 0
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        generatePentominoesPieces()
        populateBoardImage()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        displayCurrentHints()
        
    }
    
    @IBAction func okayButtonPressed(sender: UIButton) {
        delegate!.dismissHints()
    }
    
    @IBAction func dismissByCompletion(sender: AnyObject) {
        if let closure = completionBlock {
            closure()
        }
    }
    
    func populateBoardImage(){
        let currentBoardImageName = generateBoardImageName()
        boardView.image = UIImage(named: currentBoardImageName)
    }
    
    func generateBoardImageName() -> String {
        let currentBoardImageName = "Board\(currentBoardNumber).png"
        return currentBoardImageName
    }
    
    func displayCurrentHints() {
        extractBoardSolutions(currentBoardNumber)
        var loopCounter = 0
        for aView in pentominoImageViews {
            moveView(aView, toSuperview: boardView)
            let gridOriginX = CGFloat(pentominoesArray[loopCounter].solutionX) * self.gridTileConversion
            let gridOriginY = CGFloat(pentominoesArray[loopCounter].solutionY) * self.gridTileConversion
            let pieceBounds = aView.bounds
            let flipSolution = pentominoesArray[loopCounter].numFlipsSolution
            let rotationSolution = pentominoesArray[loopCounter].numRotationsSolution
            
            var pieceWidth : CGFloat = pieceBounds.width
            var pieceHeight : CGFloat = pieceBounds.height
            aView.transform = CGAffineTransformIdentity
            
            self.rotatePentominoView(aView, numRotations: rotationSolution, width: &pieceWidth, height: &pieceHeight, isSolve: true)
            
            if flipSolution != 0 {
                self.flipPentominoView(aView, numRotations: rotationSolution, x: self.negativeTransformValue, y: self.positiveTransformValue)
            }
            
            let origin = CGPoint(x: gridOriginX, y: gridOriginY)
            
            aView.frame.origin = origin
            
            
            loopCounter += 1

            
        }
    }
    
    func generatePentominoesPieces() {
        
        for i in 0..<numHints {
            let tempPentominoesPiece = pentominoesPiece()
            if let myImage = UIImage(named: "tile\(tileLettersArray[i]).png"){
                let imageView = UIImageView(image: myImage)
                
                tempPentominoesPiece.image = myImage
                tempPentominoesPiece.letter = Character(tileLettersArray[i])
                let origin = CGPoint(x: initialOrigin.x, y: initialOrigin.y)
                imageView.frame.origin = origin
                pentominoImageViews.append(imageView)
                pentominoesArray.append(tempPentominoesPiece)
                //boardView.addSubview(imageView)
            }
        }
        
    }
    
    func extractBoardSolutions(boardNumber : Int){
        if boardNumber != 0 {
            initializeSolutionPList()
            let currentDictionary = getBoardDictionary(currentBoardNumber - 1)
            populatePiecesWithCurrentAnswers(currentDictionary)
        }
    }
    
    func initializeSolutionPList(){
        if let solutionsBundlePath = NSBundle.mainBundle().pathForResource("Solutions", ofType: ".plist") {
            solutionsArray = NSArray(contentsOfFile: solutionsBundlePath)!
        }
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
    
    func getBoardDictionary(boardNum:Int) -> [String : [String : Int]] {
        let boardDictionary = solutionsArray[boardNum] as! [String : [String : Int]]
        return boardDictionary
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
    
    func configureWithBoardNumber(boardNumber :Int) {
        currentBoardNumber = boardNumber
    }
    func configureWithHintNumber(hintNumber: Int){
        numHints = hintNumber
    }
    

}

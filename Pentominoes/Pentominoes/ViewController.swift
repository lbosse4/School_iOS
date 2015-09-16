//
//  ViewController.swift
//  Pentominoes
//
//  Created by Lauren Bosse on 9/13/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boardImageView: UIImageView!
    @IBOutlet weak var petominoesContainerView: UIView!
    
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
     
        
            

       
        let pentominoContainerSize = petominoesContainerView.bounds.size
        
        model.generatePentominoesPieces(pentominoContainerSize)
        
        for i in 0..<model.numPentominoesPieces {
            let myImage = model.pentominoesArray[i].image
            let imageView = UIImageView(image: myImage)
            
            let pieceBoundSize = imageView.bounds.size
            
            imageView.frame = CGRect(x: model.pentominoesArray[i].initialX, y: model.pentominoesArray[i].initialY, width: pieceBoundSize.width, height: pieceBoundSize.height)
            
            petominoesContainerView.addSubview(imageView)
            
        }
        
    }
    
    @IBAction func boardButtonPressed(sender: AnyObject) {
        let currentBoardImageName = model.generateBoardImageName(sender)
        boardImageView.image = UIImage(named: currentBoardImageName)
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        for piece in model.pentominoesArray {
            let myImage = piece.image
            let imageView = UIImageView(image: myImage)
            
            let pieceBoundSize = imageView.bounds.size
            
            imageView.frame = CGRect(x: piece.initialX, y: piece.initialY, width: pieceBoundSize.width, height: pieceBoundSize.height)
        }
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {
    
    }
    
    

}


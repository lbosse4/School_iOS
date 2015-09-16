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
        if !model.pentominoesPiecesHaveBeenInitialized {
            let pentominoContainerSize = petominoesContainerView.bounds.size
        
            model.generatePentominoesPieces(pentominoContainerSize)
        
            for i in 0..<model.numPentominoesPieces {
                let imageView = model.setInitialPieces(model.pentominoesArray[i])
                petominoesContainerView.addSubview(imageView)
            }
            
            model.pentominoesPiecesHaveBeenInitialized = true
        }
    }
    
    @IBAction func boardButtonPressed(sender: AnyObject) {
        let currentBoardImageName = model.generateBoardImageName(sender)
        boardImageView.image = UIImage(named: currentBoardImageName)
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        for piece in model.pentominoesArray {
            model.setInitialPieces(piece)
            
            /*
            if piece.numFlips != 0 {
                
            }
            
            if piece.numRotations != 0 {
                
            }*/
            
        }
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {
    
    }
    
    

}


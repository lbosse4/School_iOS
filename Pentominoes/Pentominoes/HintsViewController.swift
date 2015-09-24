//
//  HintsViewController.swift
//  Pentominoes
//
//  Created by Lauren Bosse on 9/24/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class HintsViewController : UIViewController {

    let model = Model()
    var pentominoImageViews = [UIImageView]()
    
    override func viewDidLoad() {
        /////MAY NEED TO CHANGE THIS
        model.numHints++
        
        
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        model.generatePentominoesPieces()
        
        for i in 0..<model.numPentominoesPieces {
            let myImage = model.pentominoesArray[i].image
            let imageView = UIImageView(image: myImage)
            imageView.tag = i
            imageView.userInteractionEnabled = true
            
            pentominoImageViews.append(imageView)
            //pentominoesContainerView.addSubview(imageView)
        }
        
        
        
        
        
        //THIS WILL INIT TO ZERO. CHANGE.
        displayCurrentHints(model.numHints)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayCurrentHints(numHints : Int) {
        //CURRENTLY NUMHINTS IS ZERO
    }

}
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
        for i in 0...model.numPentominoesPieces - 1 {
            model.generatePentominoesPiece(i)
        }
    }
    
    @IBAction func boardButtonPressed(sender: AnyObject) {
        let currentBoardImageName = model.generateBoardImageName(sender)
        boardImageView.image = UIImage(named: currentBoardImageName)
    }
    
    
    /*
    for i in 0..<lionImageCount {
        let name = "Lion\(i).jpg"
        let image = UIImage(named: name)
        if let myimage = image {
            let imageView = UIImageView(image: myimage)
            imageView.frame = CGRectZero
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    
            imageViews.append(imageView)
    
        }
    }
    */
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
    
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {
    
    }
    
    

}


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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func boardButtonPressed(sender: AnyObject) {
        let currentBoardTagPressed = sender.tag
        let currentBoardImageName = "Board\(currentBoardTagPressed).png"
        
        boardImageView.image = UIImage(named: currentBoardImageName)
        
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
    
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {
    
    }
    
    

}


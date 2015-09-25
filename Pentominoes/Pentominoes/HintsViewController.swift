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
    let numPentominoesPieces = 12
    
    @IBOutlet weak var backgroudView: UIImageView!
    @IBOutlet weak var boardView: UIImageView!
    
    override func viewDidLoad() {
        /////MAY NEED TO CHANGE THIS
        
        
        
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
        
        
        
        
        
        //THIS WILL INIT TO ZERO. CHANGE.
        displayCurrentHints(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @IBAction func okayButtonPressed(sender: UIButton) {
        delegate!.dismissHints()
    }
    
    @IBAction func dismissByCompletion(sender: AnyObject) {
        if let closure = completionBlock {
            closure()
        }
    }
    
    func displayCurrentHints(numHints : Int) {
        //CURRENTLY NUMHINTS IS ZERO
    }
    
    func configureWithBoardNumber(boardNumber :Int) {
        currentBoardNumber = boardNumber
    }

}
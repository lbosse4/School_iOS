//
//  SecondHalfPromptViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/8/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class SecondHalfPromptViewController: UIViewController {
    var cancelBlock : (() -> Void)!
    
    //MARK: Actions
    @IBAction func startButtonPressed(sender: UIButton) {
        cancelBlock()
    }
    
}

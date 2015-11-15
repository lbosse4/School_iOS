//
//  CreateTeamViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class CreateTeamViewController : UIViewController {
    let model = Model.sharedInstance
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
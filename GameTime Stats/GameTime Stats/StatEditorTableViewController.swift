//
//  StatEditorTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/17/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class StatEditorTableViewController: UITableViewController {
    let model = Model.sharedInstance
    
    override func viewDidLoad() {
        
    
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        //TODO: make sure stats save here
        dismissViewControllerAnimated(true, completion: nil)
    }
}
//
//  ViewTeamsTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/18/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ViewTeamsTableViewController: UITableViewController/*, DataSourceCellConfigurer*/ {
    let model = Model.sharedInstance
    
    var cancelBlock : (() -> Void)?
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        cancelBlock?()
    }
    
}
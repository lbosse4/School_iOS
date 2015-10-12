//
//  MasterViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 10/12/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    
    var detailViewController: DetailViewController? = nil
    
    override func viewDidLoad() {
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    
    
}

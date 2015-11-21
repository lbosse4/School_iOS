//
//  AddPlayersTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/20/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class AddPlayersTableViewController: UITableViewController {
    
    let model = Model.sharedInstance
    var team : Team?
    lazy var dataSource : DataSource = DataSource(entity: "Player", sortKeys: ["name"], predicate: nil, sectionNameKeyPath: "firstLetter", delegate: self.model)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dataSource.delegate = self
//        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
//        tableView.dataSource = dataSource
    }
    
    //MARK: Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "addPlayerSegue":
            let playerController = segue.destinationViewController as! AddPlayerViewController
            playerController.team = team!
            playerController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        default:
            break
        }
    }
}

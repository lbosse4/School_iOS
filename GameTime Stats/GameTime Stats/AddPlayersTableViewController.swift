//
//  AddPlayersTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/20/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import CoreData

class AddPlayersTableViewController: UITableViewController, DataSourceCellConfigurer {
    
    let model = Model.sharedInstance
    var team : Team?
    lazy var dataSource : DataSource = DataSource(entity: "Player", sortKeys: ["name"], predicate: nil, sectionNameKeyPath: "firstLetter", delegate: self.model)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Data Source Cell Configurer
    
    func cellIdentifierForObject(object: NSManagedObject) -> String {
        return "playerCell"
    }
    
    func configureCell(cell: UITableViewCell, withObject object: NSManagedObject) {
        let player = object as? Player
        cell.textLabel!.text = player!.name
        
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

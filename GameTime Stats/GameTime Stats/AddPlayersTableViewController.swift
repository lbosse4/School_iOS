//
//  AddPlayersTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/20/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import CoreData

protocol TeamCreatedProtocol {
    func dismissMe()
}

class AddPlayersTableViewController: UITableViewController, DataSourceCellConfigurer {
    
    let model = Model.sharedInstance
    let formatter = NSNumberFormatter()
    var team : Team?
    var cancelBlock : (() -> Void)?
    var delegate : TeamCreatedProtocol?
    //TODO: UPDATE FILTER TO ONLY INCLUD ECURRENT TEAM
    lazy var dataSource : DataSource = DataSource(entity: "Player", sortKeys: ["name"], predicate: nil, sectionNameKeyPath: "firstLetter", delegate: self.model)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.minimumIntegerDigits = 2
        
        dataSource.delegate = self
        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
        tableView.dataSource = dataSource
        
        let teamName = team!.name!
        let predicate = NSPredicate(format: "team.name == %@", teamName)
        dataSource.updateWithPredicate(predicate)
        
//        let teamNamePredicate = NSPredicate(format: "team!.name! = %@", team!.name!)
//        dataSource.updateWithPredicate(teamNamePredicate)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Data Source Cell Configurer
    func cellIdentifierForObject(object: NSManagedObject) -> String {
        return "addPlayerTableViewCell"
    }
    
    func configureCell(let cell: AddPlayerTableViewCell, withObject object: NSManagedObject) {
        let player = object as? Player
        let playerName = player!.name
        cell.playerNameLabel.text = playerName
        
        let position = player?.position
        cell.positionLabel.text = position
        
        let jerseyNumber = player?.jerseyNumber
        let jerseyNumberString = formatter.stringFromNumber(jerseyNumber!)
        cell.jerseyNumberLabel.text = jerseyNumberString
    }
    
    //MARK: Actions
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        //dismissViewControllerAnimated(true, completion: nil)
        cancelBlock?()
        delegate?.dismissMe()
    }
    
   

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.playerCount()
        //TODO: USe this line instead
        //return model.numPlayersForTeam(TEAAM)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addPlayerTableViewCell", forIndexPath: indexPath) as! AddPlayerTableViewCell
        
        let player = model.playerAtIndex(indexPath.row)
        let playerName = player.name
        cell.playerNameLabel.text = playerName
        
        let position = player.position
        cell.positionLabel.text = position
        
        let jerseyNumber = player.jerseyNumber
        let jerseyNumberString = formatter.stringFromNumber(jerseyNumber!)
        cell.jerseyNumberLabel.text = jerseyNumberString
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    
    //MARK: Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "addPlayerSegue":
            let playerController = segue.destinationViewController as! AddPlayerViewController
            playerController.team = team!
            playerController.cancelBlock = {() in
                self.navigationController?.popViewControllerAnimated(true)
                self.tableView.reloadData()
            }
        default:
            break
        }
    }
}

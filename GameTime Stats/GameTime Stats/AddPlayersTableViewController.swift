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
    let sectionHeight : CGFloat = 30.0
    let titleFont = UIFont(name: "Orbitron-Medium", size: 20.0)
    var team : Team?
    var cancelBlock : (() -> Void)?
    var delegate : TeamCreatedProtocol?
    //TODO: UPDATE FILTER TO ONLY INCLUD ECURRENT TEAM
    lazy var dataSource : AddPlayerDataSource = AddPlayerDataSource(entity: "Player", sortKeys: ["name"], predicate: nil, sectionNameKeyPath: "firstLetter", delegate: self.model)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.minimumIntegerDigits = 2
        
        dataSource.delegate = self
        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
        tableView.dataSource = dataSource
        
        let teamName = team!.name!
        let predicate = NSPredicate(format: "team.name == %@", teamName)
        dataSource.updateWithPredicate(predicate)
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
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: sectionHeight)
        let sectionView = UIView(frame: sectionViewFrame)
        sectionView.backgroundColor = UIColor.blackColor()
        
        let playerNameLabelFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: sectionHeight)
        let playerNameLabel = UILabel(frame: playerNameLabelFrame)
        let playerNameFirstLetter = dataSource.tableView(tableView, titleForHeaderInSection: section)
        playerNameLabel.text = playerNameFirstLetter
        playerNameLabel.font = titleFont
        playerNameLabel.textColor = UIColor.whiteColor()
        playerNameLabel.textAlignment = NSTextAlignment.Center
        
        sectionView.addSubview(playerNameLabel)
        return sectionView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
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

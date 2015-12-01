//
//  ViewTeamsTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/18/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import CoreData

class ViewTeamsTableViewController: UITableViewController, ViewTeamsDataSourceCellConfigurer{
    let model = Model.sharedInstance
    let formatter = NSNumberFormatter()
    let buttonWidth : CGFloat = 25.0
    let sectionHeight : CGFloat = 50.0
    
    lazy var dataSource : ViewTeamsDataSource = ViewTeamsDataSource(entity: "Player", sortKeys: ["team.name", "jerseyNumber"], predicate: nil, sectionNameKeyPath: "team.name", delegate: self.model)
    
    var cancelBlock : (() -> Void)?
    
    override func viewDidLoad() {
        formatter.minimumIntegerDigits = 2
        
        dataSource.delegate = self
        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
        tableView.dataSource = dataSource
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        cancelBlock?()
    }
    
    //MARK: Data Source Cell Configurer
    func cellIdentifierForObject(object: NSManagedObject) -> String {
        return "playerCell"
    }
    
    func configureCell(let cell: PlayerTableViewCell, withObject object: NSManagedObject) {
        let player = object as? Player
        let playerName = player!.name
        cell.playerNameLabel.text = playerName
        
        let position = player?.position
        cell.positionLabel.text = position
        
        let jerseyNumber = player?.jerseyNumber
        let jerseyNumberString = formatter.stringFromNumber(jerseyNumber!)
        cell.jerseyNumberLabel.text = jerseyNumberString
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: sectionHeight)
        let sectionView = UIView(frame: sectionViewFrame)
        
        let teamNameLabelFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width - buttonWidth, height: sectionHeight)
        let teamNameLabel = UILabel(frame: teamNameLabelFrame)
        let teamName = dataSource.tableView(tableView, titleForHeaderInSection: section)
        teamNameLabel.text = teamName
        
        sectionView.addSubview(teamNameLabel)
        return sectionView
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
}
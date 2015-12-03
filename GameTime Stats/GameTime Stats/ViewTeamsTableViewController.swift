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
    let buttonWidth : CGFloat = 140.0
    let buttonHeight : CGFloat = 35.0
    let scrollPadding : CGFloat = 45.0
    let sectionHeight : CGFloat = 50.0
    let darkBlueColor = UIColor(red: 0.01, green: 0.02, blue: 0.84, alpha: 1.0)
    let titleFont = UIFont(name: "Orbitron-Medium", size: 20.0)
    let buttonFont = UIFont(name: "Orbitron-Light", size: 18.0)
    
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
    
    //MARK: Actions
    func addPlayerButtonPressed(sender: UIButton){
        let sectionTitle = dataSource.tableView(self.tableView, titleForHeaderInSection: sender.tag)!
        let team = model.teamWithName(sectionTitle)
        
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
        sectionView.backgroundColor = UIColor.blackColor()
        
        //TODO: TURN THIS INTO A BUTTON
        let teamNameLabelFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width - buttonWidth - scrollPadding, height: sectionHeight)
        let teamNameLabel = UILabel(frame: teamNameLabelFrame)
        let teamName = dataSource.tableView(tableView, titleForHeaderInSection: section)
        teamNameLabel.text = teamName
        teamNameLabel.font = titleFont
        teamNameLabel.textColor = UIColor.whiteColor()
        teamNameLabel.textAlignment = NSTextAlignment.Center
        
        let showTeamStatsButtonFrame = CGRect(x: view.frame.width - buttonWidth - scrollPadding, y: (sectionHeight - buttonHeight)/2, width: buttonWidth, height: buttonHeight)
        let showTeamStatsButton = UIButton(frame: showTeamStatsButtonFrame)
        showTeamStatsButton.addTarget(self, action: "addPlayerButtonPressed:", forControlEvents: .TouchUpInside)
        showTeamStatsButton.setTitle("Add Player", forState: .Normal)
        showTeamStatsButton.titleLabel!.font = buttonFont
        showTeamStatsButton.backgroundColor = darkBlueColor
        showTeamStatsButton.tag = section
        
        sectionView.addSubview(teamNameLabel)
        sectionView.addSubview(showTeamStatsButton)

        return sectionView
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
}
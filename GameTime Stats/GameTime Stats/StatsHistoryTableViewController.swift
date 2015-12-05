//
//  StatsHistoryTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/3/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import CoreData

class StatsHistoryTableViewController: UITableViewController, StatsHistoryDataSourceCellConfigurer {
    let model = Model.sharedInstance
    let formatter = NSNumberFormatter()
    let dateFormatter = NSDateFormatter()
    let sectionHeight : CGFloat = 50.0
    let buttonWidth : CGFloat = 140.0
    let buttonHeight : CGFloat = 35.0
    let scrollPadding : CGFloat = 45.0
    let titleFont = UIFont(name: "Orbitron-Medium", size: 20.0)
    let buttonFont = UIFont(name: "Orbitron-Light", size: 18.0)
    let darkBlueColor = UIColor(red: 0.01, green: 0.02, blue: 0.84, alpha: 1.0)
    var collapsedSections = [Bool]()

    var cancelBlock : (() -> Void)?
    
    lazy var dataSource : StatsHistoryDataSource = StatsHistoryDataSource(entity: "Game", sortKeys: ["team.name", "date"], predicate: nil, sectionNameKeyPath: "team.name", delegate: self.model)
    
    override func viewDidLoad() {
        formatter.minimumIntegerDigits = 2
        
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        
        dataSource.delegate = self
        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
        tableView.dataSource = dataSource
        
        for _ in 0..<model.teamCount() {
            collapsedSections.append(false)
        }
    }
    
    //MARK: Actions
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        cancelBlock!()
    }
    
    func collapseSection(sender: UIButton){
        collapsedSections[sender.tag] = !collapsedSections[sender.tag]
        let indexSet = NSIndexSet(index: sender.tag)
        tableView.reloadSections(indexSet, withRowAnimation: .Automatic)
    }
    
    func showTeamStatsButtonPressed(sender: UIButton){
        let sectionTitle = dataSource.tableView(self.tableView, titleForHeaderInSection: sender.tag)!
        let team = model.teamWithName(sectionTitle)
    }
    
    //MARK: Data Source Cell Configurer
    func cellIdentifierForObject(object: NSManagedObject) -> String {
        return "gameCell"
    }
    
    func configureCell(let cell: StatsHistoryTableViewCell, withObject object: NSManagedObject) {
        let game = object as? Game
        let opponentName = game!.opponentName!
        cell.opponentNameLabel.text = opponentName
        
        let date = game!.date!
        let dateString = dateFormatter.stringFromDate(date)
        cell.dateLabel.text = dateString
        
        let homeScore = game!.homeScore!
        let guestScore = game!.guestScore!
        cell.scoreLabel.text = "\(homeScore) to \(guestScore) (opponent)"
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: sectionHeight)
        let sectionView = UIView(frame: sectionViewFrame)
        sectionView.backgroundColor = UIColor.blackColor()
        
        //TODO: TURN THIS INTO A BUTTON
        let teamNameButtonFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width - buttonWidth - scrollPadding, height: sectionHeight)
        let teamNameButton = UIButton(frame: teamNameButtonFrame)
        let teamName = dataSource.tableView(tableView, titleForHeaderInSection: section)
        teamNameButton.setTitle(teamName, forState: .Normal)
        teamNameButton.titleLabel!.font = titleFont
        teamNameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        teamNameButton.addTarget(self, action: "collapseSection:", forControlEvents: .TouchUpInside)
        teamNameButton.tag = section
        
        let showTeamStatsButtonFrame = CGRect(x: view.frame.width - buttonWidth - scrollPadding, y: (sectionHeight - buttonHeight)/2, width: buttonWidth, height: buttonHeight)
        let showTeamStatsButton = UIButton(frame: showTeamStatsButtonFrame)
        showTeamStatsButton.addTarget(self, action: "showTeamStatsButtonPressed:", forControlEvents: .TouchUpInside)
        showTeamStatsButton.setTitle("Team Stats", forState: .Normal)
        showTeamStatsButton.titleLabel!.font = buttonFont
        showTeamStatsButton.backgroundColor = darkBlueColor
        showTeamStatsButton.tag = section
        
        sectionView.addSubview(teamNameButton)
        sectionView.addSubview(showTeamStatsButton)
        
        return sectionView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collapsedSections[section] {
            return 0
        } else {
            let team = model.teamAtIndex(section)
            let games = model.gamesForTeam(team)
            return games.count
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
}

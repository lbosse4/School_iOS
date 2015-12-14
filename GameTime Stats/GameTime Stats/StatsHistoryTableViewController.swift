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
    let scrollPadding : CGFloat = 45.0
    let titleFont = UIFont(name: "Orbitron-Medium", size: 20.0)
    
    var cancelBlock : (() -> Void)?
    
    lazy var dataSource : StatsHistoryDataSource = StatsHistoryDataSource(entity: "Game", sortKeys: ["team.name", "date"], predicate: nil, sectionNameKeyPath: "team.name", delegate: self.model)
    
    override func viewDidLoad() {
        formatter.minimumIntegerDigits = 2
        
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        
        dataSource.delegate = self
        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
        tableView.dataSource = dataSource
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var hasGames = false
        let teams = model.testTeams()
        for team in teams {
            if !(team.games?.allObjects.count == 0) {
                hasGames = true
                break
            }
        }
        
        //TODO: GET THIS TO PRESENt ALERT
        if !hasGames {
            
        }
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    //MARK: Actions
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        cancelBlock!()
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
        
        //for collapsable sections
        let teamNameButtonFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width - scrollPadding, height: sectionHeight)
        let teamNameButton = UIButton(frame: teamNameButtonFrame)
        let teamName = dataSource.tableView(tableView, titleForHeaderInSection: section)!
        let team = model.teamWithName(teamName)
        teamNameButton.setTitle(teamName, forState: .Normal)
        teamNameButton.titleLabel!.font = titleFont
        teamNameButton.backgroundColor = model.majorColorForTeam(team)
        teamNameButton.setTitleColor(model.minorColorForTeam(team), forState: .Normal)
        teamNameButton.tag = section
        
        sectionView.addSubview(teamNameButton)
        
        return sectionView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "gameStatsTableViewSegue":
            let gameStatsTableViewController = segue.destinationViewController as! GameStatsTableViewController
            let indexPath = tableView.indexPathForSelectedRow
            let game = dataSource.objectAtIndexPath(indexPath!) as! Game
            let team = game.team!
            gameStatsTableViewController.game = game
            gameStatsTableViewController.team = team
        default:
            break
        }
    }
    
}

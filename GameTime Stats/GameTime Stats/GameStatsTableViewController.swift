//
//  GameStatsTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/5/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import CoreData

class GameStatsTableViewController: UITableViewController, GameStatsDataSourceCellConfigurer {
    let model = Model.sharedInstance
    let formatter = NSNumberFormatter()
    let sectionHeight : CGFloat = 30.0
    let scrollPadding : CGFloat = 45.0
    let titleFont = UIFont(name: "Orbitron-Medium", size: 20.0)
    let blueColor = UIColor(red:0.00, green:0.00, blue:0.86, alpha:1.0)
    
    var game : Game!
    var team : Team!
    lazy var dataSource : GameStatsDataSource = GameStatsDataSource(entity: "Player", sortKeys: ["name"], predicate: nil, sectionNameKeyPath: "firstLetter", delegate: self.model)
    
    // cell: gameStatsCell
    
    override func viewDidLoad() {
        formatter.minimumIntegerDigits = 2
        
        dataSource.delegate = self
        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
        tableView.dataSource = dataSource
        
        
        let teamName = team!.name!
        let predicate = NSPredicate(format: "team.name == %@", teamName)
        dataSource.updateWithPredicate(predicate)
        
        self.navigationItem.title = "Game vs. \(game!.opponentName!)"
    }
    
    //MARK: Data Source Cell Configurer
    func cellIdentifierForObject(object: NSManagedObject) -> String {
        return "gameStatsCell"
    }
    
    func configureCell(let cell: GameStatsTableViewCell, withObject object: NSManagedObject) {
        let player = object as? Player
        let playerName = player!.name
        cell.playerNameLabel.text = playerName
        
        let position = player?.position
        cell.positionLabel.text = position
        
        let jerseyNumber = player?.jerseyNumber
        let jerseyNumberString = formatter.stringFromNumber(jerseyNumber!)
        cell.jerseyNumber.text = jerseyNumberString
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: sectionHeight)
        let sectionView = UIView(frame: sectionViewFrame)
        sectionView.backgroundColor = UIColor.blackColor()
        
        //for collapsable sections 
        let teamNameButtonFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width - scrollPadding, height: sectionHeight)
        let teamNameButton = UIButton(frame: teamNameButtonFrame)
        let teamName = dataSource.tableView(tableView, titleForHeaderInSection: section)
        teamNameButton.setTitle(teamName, forState: .Normal)
        teamNameButton.titleLabel!.font = titleFont
        teamNameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        teamNameButton.tag = section
        
        sectionView.addSubview(teamNameButton)
        
        return sectionView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }

    //MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "playerStatsSegue":
            let playerStatsViewController = segue.destinationViewController as! PlayerStatsViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            let player = dataSource.objectAtIndexPath(indexPath!) as! Player
            playerStatsViewController.player = player
            playerStatsViewController.game = game
            playerStatsViewController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        case "showTeamStatsSegue":
            let teamStatsViewController = segue.destinationViewController as! TeamStatsViewController
            teamStatsViewController.team = team
            teamStatsViewController.game = game
            teamStatsViewController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        default:
            break
        }
    }
    
    
    
}

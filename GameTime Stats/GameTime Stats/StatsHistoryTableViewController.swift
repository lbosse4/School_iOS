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
    var cancelBlock : (() -> Void)?
    
    lazy var dataSource : StatsHistoryDataSource = StatsHistoryDataSource(entity: "Game", sortKeys: ["team.name", "date"], predicate: nil, sectionNameKeyPath: "team.name", delegate: self.model)
    
    override func viewDidLoad() {
        formatter.minimumIntegerDigits = 2
        
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        
        dataSource.delegate = self
        dataSource.tableView = tableView // fetchresultscontroller delegate needs to know this!
        tableView.dataSource = dataSource
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
//        let playerName = player!.name
//        cell.playerNameLabel.text = playerName
//        
//        let position = player?.position
//        cell.positionLabel.text = position
//        
//        let jerseyNumber = player?.jerseyNumber
//        let jerseyNumberString = formatter.stringFromNumber(jerseyNumber!)
//        cell.jerseyNumberLabel.text = jerseyNumberString
    }

    
}

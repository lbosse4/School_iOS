//
//  TeamStatsViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/5/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class TeamStatsViewController: UIViewController {
    let dateFormatter = NSDateFormatter()

    var team : Team!
    var game : Game!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //**TODO: NOT DONE YET
    
    override func viewDidLoad() {
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        
        let teamName = team.name!
        teamNameLabel.text = teamName
        
        let opponentName = game.opponentName!
        opponentNameLabel.text = opponentName
        
        let date = game.date!
        let dateString = dateFormatter.stringFromDate(date)
        dateLabel.text = dateString
        
        let homeScore = Int(game.homeScore!)
        let guestScore = Int(game.guestScore!)
        var winnerIndicator = ""
        if homeScore > guestScore {
            winnerIndicator = "Won"
        } else if homeScore < guestScore {
            winnerIndicator = "Lost"
        } else {
            winnerIndicator = "Tied"
        }
        
        let score = "\(winnerIndicator) \(homeScore) to \(guestScore)"
        scoreLabel.text = score
    }

}


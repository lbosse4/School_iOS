//
//  PlayerStatsViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/5/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class PlayerStatsViewController: UIViewController{
    let dateFormatter = NSDateFormatter()
    var player : Player!
    var game : Game!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        
        let playerName = player.name!
        playerNameLabel.text = playerName
        
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
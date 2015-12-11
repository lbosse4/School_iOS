//
//  TeamStatsDetailViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/10/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class TeamStatsDetailViewController: UIViewController {
    //MARK: Summary Outlets
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //MARK: Stat Label Outlets
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var causedTurnoversLabel: UILabel!
    @IBOutlet weak var clearsLabel: UILabel!
    @IBOutlet weak var drawControlsLabel: UILabel!
    @IBOutlet weak var freePositionAttemptsLabel: UILabel!
    @IBOutlet weak var freePositionGoalsLabel: UILabel!
    @IBOutlet weak var freePositionPercentageLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var groundBallsLabel: UILabel!
    @IBOutlet weak var opponentGoalsScoredAgainstLabel: UILabel!
    @IBOutlet weak var savePercentageLabel: UILabel!
    @IBOutlet weak var savesLabel: UILabel!
    @IBOutlet weak var shotPercentageLabel: UILabel!
    @IBOutlet weak var shotsOnGoalLabel: UILabel!
    @IBOutlet weak var turnoversLabel: UILabel!
    
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    
    let dateFormatter = NSDateFormatter()
    let model = Model.sharedInstance
    let formatter = NSNumberFormatter()
    let secondsPerMinute : Int = 60
    
    var pageIndex: Int?
    var team : Team!
    var game : Game!
    
    override func viewDidLoad() {
        //MARK: setting title/Constants
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        formatter.minimumIntegerDigits = 2
        formatter.maximumFractionDigits = 2
        
        let players = team.players?.allObjects as! [Player]
        let numPeriods = model.allStatsForPlayer(players[0], game: game).count
        if pageIndex == numPeriods - 1 {
            directionsLabel.hidden = true
        } else {
            directionsLabel.hidden = false
        }
    
        //MARK: Setting Title/Constants
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
        
        //Setting Period
        var periodType = PeriodType.FirstHalf
        switch pageIndex! {
        case 0:
            periodType = PeriodType.FirstHalf
        case 1:
            periodType = PeriodType.SecondHalf
        case 2:
            periodType = PeriodType.Overtime
        default:
            break
        }
        periodLabel.text = periodType
        
        var numAssists = 0
        var numCausedTurnovers = 0
        var numClears = 0
        var numDrawControls = 0
        var numFreePositionAttempts = 0
        var numFreePositionGoals = 0
        var numGoals = 0
        var numGroundBalls = 0
        var numGoalsAgainst = 0
        var numSaves = 0
        var numShotsOnGoal = 0
        var numTurnovers = 0
        
        //add up all team stats for this period
        for player in players {
            let stats = model.statsForPlayer(player, game: game, periodType: periodType)
            numAssists += Int(stats.assists!)
            numCausedTurnovers += Int(stats.causedTurnovers!)
            numClears += Int(stats.clears!)
            numDrawControls += Int(stats.drawControls!)
            numFreePositionAttempts += Int(stats.freePositionAttempts!)
            numFreePositionGoals += Int(stats.freePositionGoals!)
            numGoals += Int(stats.goals!)
            numGroundBalls += Int(stats.groundBalls!)
            numGoalsAgainst += Int(stats.opponentGoalsScoredAgainst!)
            numSaves += Int(stats.saves!)
            numShotsOnGoal += Int(stats.shotsOnGoal!)
            numTurnovers += Int(stats.turnovers!)
        }
        
        assistsLabel.text = formatter.stringFromNumber(numAssists)
        causedTurnoversLabel.text = formatter.stringFromNumber(numCausedTurnovers)
        clearsLabel.text = formatter.stringFromNumber(numClears)
        drawControlsLabel.text = formatter.stringFromNumber(numDrawControls)
        freePositionAttemptsLabel.text = formatter.stringFromNumber(numFreePositionAttempts)
        freePositionGoalsLabel.text = formatter.stringFromNumber(numFreePositionGoals)
        
        if numFreePositionAttempts == 0{
            freePositionPercentageLabel.text = formatter.stringFromNumber(0)
        } else {
            let freePositionPercentage : Double = (Double(numFreePositionGoals) / Double(numFreePositionAttempts))
            freePositionPercentageLabel.text = formatter.stringFromNumber(freePositionPercentage)
        }
        
        goalsLabel.text = formatter.stringFromNumber(numGoals)
        groundBallsLabel.text = formatter.stringFromNumber(numGroundBalls)
        opponentGoalsScoredAgainstLabel.text = formatter.stringFromNumber(numGoalsAgainst)
        savesLabel.text = formatter.stringFromNumber(numSaves)
        shotsOnGoalLabel.text = formatter.stringFromNumber(numShotsOnGoal)
        turnoversLabel.text = formatter.stringFromNumber(numTurnovers)

        if numShotsOnGoal == 0{
            shotPercentageLabel.text = formatter.stringFromNumber(0)
        } else {
            let shotPercentage : Double = (Double(numGoals) / Double(numShotsOnGoal))
            shotPercentageLabel.text = formatter.stringFromNumber(shotPercentage)
        }
        
        let opponentShotsOnGoal = Int(numSaves) + Int(numGoalsAgainst)
        if opponentShotsOnGoal == 0{
            savePercentageLabel.text = formatter.stringFromNumber(0)
        } else {
            let savePercentage : Double = (Double(numSaves) / Double(opponentShotsOnGoal))
            shotPercentageLabel.text = formatter.stringFromNumber(savePercentage)
        }
    }
    
    func configure(team : Team, game : Game, index : Int){
        pageIndex = index
        self.game = game
        self.team = team
    }
    
}
//
//  PlayerStatsDetailViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/6/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit


class PlayerStatsDetailViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
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
    @IBOutlet weak var timePlayedLabel: UILabel!
    
    @IBOutlet weak var directionsLabel: UILabel!
    
    let model = Model.sharedInstance
    let dateFormatter = NSDateFormatter()
    let formatter = NSNumberFormatter()
    let secondsPerMinute : Int = 60
    let numPeriodsWithOvertime = 3
    let numPeriodsWithoutOvertime = 2
    
    var pageIndex: Int?
    var player: Player!
    var game: Game!
    
    override func viewDidLoad() {
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        formatter.minimumIntegerDigits = 2
        formatter.maximumFractionDigits = 2
        
        //if the user has reached the last page, do not direct them to continue to swipe
        if Bool(game.hasOvertime!) {
            
            if pageIndex == numPeriodsWithOvertime - 1 {
                directionsLabel.hidden = true
            } else {
                directionsLabel.hidden = false
            }
        } else {
            if pageIndex == numPeriodsWithoutOvertime - 1 {
                directionsLabel.hidden = true
            } else {
                directionsLabel.hidden = false
            }
        }
        
        //MARK: Setting Title/Constants
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
        
        //Setting Period Indicator
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
        
        let stats = model.statsForPlayer(player, game: game, periodType: periodType)
        periodLabel.text = periodType
        
        //Setting Stats Labels
        let numAssists = stats.assists!
        assistsLabel.text = formatter.stringFromNumber( numAssists)
        
        let numCausedTurnovers = stats.causedTurnovers!
        causedTurnoversLabel.text = formatter.stringFromNumber(numCausedTurnovers)
        
        let numClears = stats.clears!
        clearsLabel.text = formatter.stringFromNumber(numClears)
        
        let numDrawControls = stats.drawControls!
        drawControlsLabel.text = formatter.stringFromNumber(numDrawControls)
        
        let numFreePositionAttempts = stats.freePositionAttempts!
        freePositionAttemptsLabel.text = formatter.stringFromNumber(numFreePositionAttempts)
        
        let numFreePositionGoals = stats.freePositionGoals!
        freePositionGoalsLabel.text = formatter.stringFromNumber(numFreePositionGoals)
        
        if Int(numFreePositionAttempts) == 0{
            freePositionPercentageLabel.text = formatter.stringFromNumber(0)
        } else {
            let freePositionPercentage : Double = (Double(numFreePositionGoals) / Double(numFreePositionAttempts))
            freePositionPercentageLabel.text = formatter.stringFromNumber(freePositionPercentage)
        }
        
        let numGoals = stats.goals!
        goalsLabel.text = formatter.stringFromNumber(numGoals)
        
        let numGroundBalls = stats.groundBalls!
        groundBallsLabel.text = formatter.stringFromNumber(numGroundBalls)
        
        let numGoalsAgainst = stats.opponentGoalsScoredAgainst!
        opponentGoalsScoredAgainstLabel.text = formatter.stringFromNumber(numGoalsAgainst)
        
        let numSaves = stats.saves!
        savesLabel.text = formatter.stringFromNumber(numSaves)
        
        let numShotsOnGoal = stats.shotsOnGoal!
        shotsOnGoalLabel.text = formatter.stringFromNumber(numShotsOnGoal)
        
        let numTurnovers = stats.turnovers!
        turnoversLabel.text = formatter.stringFromNumber(numTurnovers)
        
        if Int(numShotsOnGoal) == 0{
            shotPercentageLabel.text = formatter.stringFromNumber(0)
        } else {
            let shotPercentage : Double = (Double(numGoals) / Double(numShotsOnGoal))
            shotPercentageLabel.text = formatter.stringFromNumber(shotPercentage)
        }
        
        let opponentShotsOnGoal = Int(numSaves) + Int(numGoalsAgainst)
        if Int(opponentShotsOnGoal) == 0{
            savePercentageLabel.text = formatter.stringFromNumber(0)
        } else {
            let savePercentage : Double = (Double(numSaves) / Double(opponentShotsOnGoal))
            shotPercentageLabel.text = formatter.stringFromNumber(savePercentage)
        }
        
        let overallSecondsPlayed = stats.secondsPlayed!
        let minutesPlayed : Int = Int(overallSecondsPlayed) / secondsPerMinute
        let minutesPlayedString = formatter.stringFromNumber(minutesPlayed)
        let secondsPlayed : Int = Int(overallSecondsPlayed) % secondsPerMinute
        let secondsPlayedString = formatter.stringFromNumber(secondsPlayed)
        timePlayedLabel.text = "\(minutesPlayedString!):\(secondsPlayedString!)"
    }
    
    func configure(player : Player, game : Game, index : Int){
        pageIndex = index
        self.game = game
        self.player = player
    }
}

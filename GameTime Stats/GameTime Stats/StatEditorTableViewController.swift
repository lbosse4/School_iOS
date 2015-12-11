//
//  StatEditorTableViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/17/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class StatEditorTableViewController: UITableViewController {
    let model = Model.sharedInstance
    let formatter = NSNumberFormatter()

    var player : Player!
    var period : String!
    var game : Game!
    var stats : Stats!
    //var period : Period?

    var cancelBlock : (() -> Void)?
    
    //MARK: Outlets
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var causedTurnoversLabel: UILabel!
    @IBOutlet weak var clearsLabel: UILabel!
    @IBOutlet weak var drawControlsLabel: UILabel!
    @IBOutlet weak var freePositionAttemptsLabel: UILabel!
    @IBOutlet weak var freePositionGoalsLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var groundBallsLabel: UILabel!
    @IBOutlet weak var opponentGoalsScoredAgainstLabel: UILabel!
    @IBOutlet weak var savesLabel: UILabel!
    @IBOutlet weak var shotsOnGoalLabel: UILabel!
    @IBOutlet weak var turnoversLabel: UILabel!
    
    @IBOutlet weak var assistsStepper: UIStepper!
    @IBOutlet weak var causedTurnoversStepper: UIStepper!
    @IBOutlet weak var clearsStepper: UIStepper!
    @IBOutlet weak var drawControlsStepper: UIStepper!
    @IBOutlet weak var freePositionAttemptsStepper: UIStepper!
    @IBOutlet weak var freePositionGoalsStepper: UIStepper!
    @IBOutlet weak var goalsStepper: UIStepper!
    @IBOutlet weak var groundBallsStepper: UIStepper!
    @IBOutlet weak var opponentGoalsScoredAgainstStepper: UIStepper!
    @IBOutlet weak var savesStepper: UIStepper!
    @IBOutlet weak var shotsOnGoalStepper: UIStepper!
    @IBOutlet weak var turnoversStepper: UIStepper!
    
    @IBOutlet var steppers: [UIStepper]!
    
    override func viewDidLoad() {
        for stepper in steppers {
            stepper.minimumValue = 0
            stepper.maximumValue = 99
        }
        
        formatter.minimumIntegerDigits = 2
        
        stats = model.statsForPlayer(player, game: game, periodType: period)
        
        let numAssists = stats.assists!
        assistsLabel.text = formatter.stringFromNumber( numAssists)
        assistsStepper.value = Double(numAssists)
        
        let numCausedTurnovers = stats.causedTurnovers!
        causedTurnoversLabel.text = formatter.stringFromNumber(numCausedTurnovers)
        causedTurnoversStepper.value = Double(numCausedTurnovers)
        
        let numClears = stats.clears!
        clearsLabel.text = formatter.stringFromNumber(numClears)
        clearsStepper.value = Double(numClears)
        
        let numDrawControls = stats.drawControls!
        drawControlsLabel.text = formatter.stringFromNumber(numDrawControls)
        drawControlsStepper.value = Double(numDrawControls)
        
        let numFreePositionAttempts = stats.freePositionAttempts!
        freePositionAttemptsLabel.text = formatter.stringFromNumber(numFreePositionAttempts)
        freePositionAttemptsStepper.value = Double(numFreePositionAttempts)
        
        let numFreePositionGoals = stats.freePositionGoals!
        freePositionGoalsLabel.text = formatter.stringFromNumber(numFreePositionGoals)
        freePositionGoalsStepper.value = Double(numFreePositionGoals)

        let numGoals = stats.goals!
        goalsLabel.text = formatter.stringFromNumber(numGoals)
        goalsStepper.value = Double(numGoals)

        let numGroundBalls = stats.groundBalls!
        groundBallsLabel.text = formatter.stringFromNumber(numGroundBalls)
        groundBallsStepper.value = Double(numGroundBalls)
        
        let numGoalsAgainst = stats.opponentGoalsScoredAgainst!
        opponentGoalsScoredAgainstLabel.text = formatter.stringFromNumber(numGoalsAgainst)
        opponentGoalsScoredAgainstStepper.value = Double(numGoalsAgainst)
        
        let numSaves = stats.saves!
        savesLabel.text = formatter.stringFromNumber(numSaves)
        savesStepper.value = Double(numSaves)
        
        let numShotsOnGoal = stats.shotsOnGoal!
        shotsOnGoalLabel.text = formatter.stringFromNumber(numShotsOnGoal)
        shotsOnGoalStepper.value = Double(numShotsOnGoal)
        
        let numTurnovers = stats.turnovers!
        turnoversLabel.text = formatter.stringFromNumber(numTurnovers)
        turnoversStepper.value = Double(numTurnovers)
    }
    
    //MARK: Actions
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        //dismiss the view controller
        model.saveDMContext()
        cancelBlock?()
    }
    
    //set values for stepper 
    @IBAction func stepperToggled(sender: UIStepper) {
        switch sender.tag {
        case 0:
            let numAssists = Int(sender.value)
            assistsLabel.text = formatter.stringFromNumber( numAssists)
            stats.assists! = numAssists
        case 1:
            let numCausedTurnovers = Int(sender.value)
            causedTurnoversLabel.text = formatter.stringFromNumber(numCausedTurnovers)
            stats.causedTurnovers! = numCausedTurnovers
        case 2:
            let numClears = Int(sender.value)
            clearsLabel.text = formatter.stringFromNumber(numClears)
            stats.clears! = numClears
        case 3:
            let numDrawControls = Int(sender.value)
            drawControlsLabel.text = formatter.stringFromNumber(numDrawControls)
            stats.drawControls! = numDrawControls
        case 4:
            let numFreePositionAttempts = Int(sender.value)
            freePositionAttemptsLabel.text = formatter.stringFromNumber(numFreePositionAttempts)
            stats.freePositionAttempts! = numFreePositionAttempts
        case 5:
            //TODO: LINK THIS WITH GOALS. EVERY FREE POSITION GOAL IS A GOAL
            let numFreePositionGoals = Int(sender.value)
            freePositionGoalsLabel.text = formatter.stringFromNumber(numFreePositionGoals)
            stats.freePositionGoals = numFreePositionGoals
        case 6:
            let numGoals = Int(sender.value)
            goalsLabel.text = formatter.stringFromNumber(numGoals)
            stats.goals! = numGoals
        case 7:
            let numGroundBalls = Int(sender.value)
            groundBallsLabel.text = formatter.stringFromNumber(numGroundBalls)
            stats.groundBalls! = numGroundBalls
        case 8:
            let numGoalsAgainst = Int(sender.value)
            opponentGoalsScoredAgainstLabel.text = formatter.stringFromNumber(numGoalsAgainst)
            stats.opponentGoalsScoredAgainst = numGoalsAgainst
        case 9:
            let numSaves = Int(sender.value)
            savesLabel.text = formatter.stringFromNumber(numSaves)
            stats.saves = numSaves
        case 10:
            let numShotsOnGoal = Int(sender.value)
            shotsOnGoalLabel.text = formatter.stringFromNumber(numShotsOnGoal)
            stats.shotsOnGoal! = numShotsOnGoal
        case 11:
            let numTurnovers = Int(sender.value)
            turnoversLabel.text = formatter.stringFromNumber(numTurnovers)
            stats.turnovers! = numTurnovers
        default:
            break
        }
        
    }
    
}












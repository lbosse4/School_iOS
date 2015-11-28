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
    var player : Player?
    
//    @NSManaged var assists: NSNumber?
//    @NSManaged var causedTurnovers: NSNumber?
//    @NSManaged var clears: NSNumber?
//    @NSManaged var drawControls: NSNumber?
//    @NSManaged var freePositionAttempts: NSNumber?
//    @NSManaged var freePositionGoals: NSNumber?
//    @NSManaged var goals: NSNumber?
//    @NSManaged var groundBalls: NSNumber?
//    @NSManaged var opponentGoalsScoredAgainst: NSNumber?
//    @NSManaged var saves: NSNumber?
//    @NSManaged var shotsOnGoal: NSNumber?
//    @NSManaged var turnovers: NSNumber?
    
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
        
        //let playerStats = player?.stats?.allObjects
        let playerStats = model.tstPlayers()[0].stats?.allObjects
        
        assistsLabel.text = "\(playerStats)"
        
        //assistsLabel.text = whateverThePlayerAlreadyHas
        //assistsStepper.value = the number used above
        
        
    }
    
    //MARK: Actions
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        //TODO: make sure stats save here
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //set values for stepper 
    @IBAction func stepperToggled(sender: UIStepper) {
        switch sender.tag {
        case 0:
            assistsLabel.text = "\(Int(sender.value))"
        case 1:
            causedTurnoversLabel.text = "\(Int(sender.value))"
        case 2:
            clearsLabel.text = "\(Int(sender.value))"
        case 3:
            drawControlsLabel.text = "\(Int(sender.value))"
        case 4:
            freePositionAttemptsLabel.text = "\(Int(sender.value))"
        case 5:
            freePositionGoalsLabel.text = "\(Int(sender.value))"
        case 6:
            goalsLabel.text = "\(Int(sender.value))"
        case 7:
            groundBallsLabel.text = "\(Int(sender.value))"
        case 8:
            opponentGoalsScoredAgainstLabel.text = "\(Int(sender.value))"
        case 9:
            savesLabel.text = "\(Int(sender.value))"
        case 10:
            shotsOnGoalLabel.text = "\(Int(sender.value))"
        case 11:
            turnoversLabel.text = "\(Int(sender.value))"
        default:
            break
        }
    }
    
}












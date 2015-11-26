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
    
    override func viewDidLoad() {
        
    
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        //TODO: make sure stats save here
        dismissViewControllerAnimated(true, completion: nil)
    }
}
//
//  StartScreenViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class StartScreenViewController : UIViewController {
    let model = Model.sharedInstance
    let inactiveAlpha : CGFloat = 0.5
    let activeAlpha : CGFloat = 1.0
    
    //MARK: Outlets
    @IBOutlet weak var viewCurrentTeamsButton: UIButton!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var statsHistoryButton: UIButton!
    
    override func viewDidLoad() {
        //Makes sure to delete teams with no players. They are not accessable.
        for team in model.teams {
            if team.players!.allObjects.count == 0 {
                model.deleteTeam(team)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //user can only access other functions if a team is made
        if model.teamCount() == 0{
            //make other features inactive
            viewCurrentTeamsButton.userInteractionEnabled = false
            viewCurrentTeamsButton.alpha = inactiveAlpha
            startGameButton.userInteractionEnabled = false
            startGameButton.alpha = inactiveAlpha
            statsHistoryButton.userInteractionEnabled = false
            statsHistoryButton.alpha = inactiveAlpha
            directionsLabel.hidden = false
        } else {
            //make other features active
            viewCurrentTeamsButton.userInteractionEnabled = true
            viewCurrentTeamsButton.alpha = activeAlpha
            startGameButton.userInteractionEnabled = true
            startGameButton.alpha = activeAlpha
            statsHistoryButton.userInteractionEnabled = true
            statsHistoryButton.alpha = activeAlpha
            directionsLabel.hidden = true
        }
    }
    
    //MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "addTeamSegue":
            let createTeamController = segue.destinationViewController as! CreateTeamViewController
        
            createTeamController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: nil)
            }

        case "viewTeamsSegue":
            let navController = segue.destinationViewController as! UINavigationController
            let viewTeamsController = navController.viewControllers[0] as! ViewTeamsTableViewController
            
            viewTeamsController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        case "statsHistorySegue":
            let navController = segue.destinationViewController as! UINavigationController
            let statsHistoryController = navController.viewControllers[0] as! StatsHistoryTableViewController
            
            statsHistoryController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        case "startGameSegue":
            let gameViewController = segue.destinationViewController as! GameViewController
            
            gameViewController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        default:
            break
        }
    }
}

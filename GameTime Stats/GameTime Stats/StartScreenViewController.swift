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
            //let playerController = navController.viewControllers[0] as! AddPlayersTableViewController
            let viewTeamsController = navController.viewControllers[0] as! ViewTeamsTableViewController
            
            viewTeamsController.cancelBlock = {() in
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

//
//  CreateTeamViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class CreateTeamViewController : UIViewController, UITextFieldDelegate {
    let model = Model.sharedInstance
    @IBOutlet weak var teamNameTextField: UITextField!
    
    override func viewDidLoad() {
        teamNameTextField.delegate = self
    }
    
    //MARK: Actions
    @IBAction func cancelButtonPressed(sender: UIButton) {
        //TODO: REMOVE TEAM FROM DATABASE IF ADDED
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addPlayerButtonPressed(sender: UIButton) {
        //TODO: MAKE TEAM NAMES UNIQUE
        
        let teamName = teamNameTextField.text!
        
        if teamName.isEmpty {
            let alert = UIAlertController(title: "Invalid", message: "Team's name cannot be blank", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            //add team to the database
            //TODO: MAYBE MOVE THIS TO COMPLETION BLOCK OF ADD PLAYERS
            model.addTeamWithName(teamName)
        }

    }
    
    //MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "addPlayerSegue":
            //Pass team to vc
            break
        default:
            break
        }
    }
    
}





//
//  CreateTeamViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//
//  All textField manipulation code came from the source listed in the StringUtils.swift file

import UIKit

class CreateTeamViewController : UIViewController, UITextFieldDelegate {
    let model = Model.sharedInstance
    let maxTeamNameLength = 40
    let inactiveAlpha : CGFloat = 0.5
    let activeAlpha : CGFloat = 1.0
    var team : Team?
    var teamName : String?
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var addPlayersButtonView: UIView!
    
    override func viewDidLoad() {
        teamNameTextField.delegate = self
        addPlayersButtonView.userInteractionEnabled = false
        addPlayersButtonView.alpha = inactiveAlpha
    }
    
    //MARK: Actions
    @IBAction func cancelButtonPressed(sender: UIButton) {
        //TODO: REMOVE TEAM FROM DATABASE IF ADDED
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addPlayerButtonPressed(sender: UIButton) {
        //TODO: MAKE TEAM NAMES UNIQUE
        
        teamName = teamNameTextField.text!
        
        if teamName!.isEmpty {
            let alert = UIAlertController(title: "Invalid", message: "Team's name cannot be blank", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            //add team to the database
            //TODO: MAYBE MOVE THIS TO COMPLETION BLOCK OF ADD PLAYERS
            team = model.addTeamWithName(teamName!)
        
        }

    }
    
    //MARK: Helper Functions
    func checkTeamNameLength(){
        if teamNameTextField.text != "" {
            addPlayersButtonView.userInteractionEnabled = true
            addPlayersButtonView.alpha = activeAlpha
        } else {
            addPlayersButtonView.userInteractionEnabled = false
            addPlayersButtonView.alpha = inactiveAlpha
        }
    }
    
    //MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        checkTeamNameLength()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkTeamNameLength()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // We still return true to allow the change to take place.
        if string.characters.count == 0 {
            return true
        }
        
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return prospectiveText.characters.count <= maxTeamNameLength
    }
    
    //MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "addPlayersTableViewSegue":
            let navController = segue.destinationViewController as! UINavigationController
            let playerController = navController.viewControllers[0] as! AddPlayersTableViewController
            playerController.team = team!
            break
        default:
            break
        }
    }
    
}





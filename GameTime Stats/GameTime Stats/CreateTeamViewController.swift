//
//  CreateTeamViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//
//  All textField manipulation code came from the source listed in the StringUtils.swift file

import UIKit

class CreateTeamViewController : UIViewController, UITextFieldDelegate, TeamCreatedProtocol {
    let model = Model.sharedInstance
    let maxTeamNameLength = 25
    let inactiveAlpha : CGFloat = 0.5
    let activeAlpha : CGFloat = 1.0
    var team : Team?
    var teamName : String?
    var cancelBlock : (() -> Void)?
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var addPlayersButtonView: UIView!
    
    override func viewDidLoad() {
        teamNameTextField.delegate = self
        addPlayersButtonView.userInteractionEnabled = false
        addPlayersButtonView.alpha = inactiveAlpha
    }
    
    //MARK: Actions
    @IBAction func cancelButtonPressed(sender: UIButton) {
        cancelBlock?()
    }
    
    @IBAction func addPlayersButtonPressed(sender: UIButton) {
        //TODO: MAKE TEAM NAMES UNIQUE AND ALSO JERSEY NUMBERS ON NEXT SCREEN
        teamName = teamNameTextField.text!
        team = model.addTeamWithName(teamName!)
    }
    
    //MARK: Helper Functions
    //make sure the team name is filled out before moving on
    func checkTeamNameLength(){
        if teamNameTextField.text != "" {
            addPlayersButtonView.userInteractionEnabled = true
            addPlayersButtonView.alpha = activeAlpha
        } else {
            addPlayersButtonView.userInteractionEnabled = false
            addPlayersButtonView.alpha = inactiveAlpha
        }
    }
    
    func dismissMe() {
        cancelBlock?()
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
            playerController.delegate = self
            
            playerController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            break
        default:
            break
        }
    }
    
}





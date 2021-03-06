//
//  CreateTeamViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//
//  All textField manipulation code came from the source listed in the StringUtils.swift file

import UIKit

class CreateTeamViewController : UIViewController, UITextFieldDelegate, TeamCreatedProtocol, UIGestureRecognizerDelegate {
    let model = Model.sharedInstance
    let maxTeamNameLength = 25
    let inactiveAlpha : CGFloat = 0.5
    let activeAlpha : CGFloat = 1.0
    let blueColor = UIColor(red:0.00, green:0.00, blue:0.86, alpha:1.0)
    
    
    var majorColor : UIColor?
    var minorColor : UIColor?
    var team : Team?
    var teamName : String?
    var cancelBlock : (() -> Void)?
    var isUniqueName = true
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var addPlayersButtonView: UIView!
    @IBOutlet weak var playerIconView: UIView!
    @IBOutlet weak var playerIconNumberLabel: UILabel!
    
    override func viewDidLoad() {
        teamNameTextField.delegate = self
        addPlayersButtonView.userInteractionEnabled = false
        addPlayersButtonView.alpha = inactiveAlpha
        let playerIconFrame = playerIconView.frame
        playerIconView.layer.cornerRadius = playerIconFrame.width/2
        majorColor = blueColor
        self.playerIconView.backgroundColor = blueColor
        minorColor = UIColor.whiteColor()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //MARK: Actions
    
    @IBAction func chooseJerseyColorButtonPressed(sender: UIButton) {
        let colorPickerViewController = storyboard!.instantiateViewControllerWithIdentifier("ColorPickerViewController") as! ColorPickerViewController
        
        colorPickerViewController.previousColor = majorColor
        colorPickerViewController.completionBlock = {(chosenColor : UIColor) in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.majorColor = chosenColor
            self.playerIconView.backgroundColor = chosenColor
        
        }
        colorPickerViewController.cancelBlock = {() in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(colorPickerViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func chooseNumberColorButtonPressed(sender: UIButton) {
        let colorPickerViewController = storyboard!.instantiateViewControllerWithIdentifier("ColorPickerViewController") as! ColorPickerViewController
        colorPickerViewController.previousColor = minorColor
        colorPickerViewController.completionBlock = {(chosenColor : UIColor) in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.minorColor = chosenColor
            self.playerIconNumberLabel.textColor = chosenColor
        
        }
        colorPickerViewController.cancelBlock = {() in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(colorPickerViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        cancelBlock?()
    }
    
    @IBAction func addPlayersButtonPressed(sender: UIButton) {
        teamName = teamNameTextField.text!
        let teams = model.testTeams()
        isUniqueName = true
        //make sure the team name is unique to this team
        for team in teams {
            let tmName = team.name!
            if tmName == teamName {
                isUniqueName = false
                break
            }
        }
        
        if isUniqueName {
            team = model.addTeamWithName(teamName!, majorColor: majorColor!, minorColor: minorColor!)
        } else {
            let alert = UIAlertController(title: "A team's name must be unique.", message: "The team name \(teamName!) is already taken.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    let players = self.team!.players?.allObjects as! [Player]
                
                    if players.count == 0 {
                        self.model.deleteTeam(self.team!)
                    }
                })
            }
            
            break
        default:
            break
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
            //the segue should not perform if the name is not unique
            case "addPlayersTableViewSegue":
                if isUniqueName {
                    return true
                } else {
                    return false
                }
            default:
                   return true
            }
    }
    
}





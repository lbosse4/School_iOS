//
//  GameSetupViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/28/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class GameSetupViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    //MARK: Constants
    let model = Model.sharedInstance
    let inactiveAlpha : CGFloat = 0.5
    let activeAlpha : CGFloat = 1.0
    let maxPlayerNameLength = 75
    
    //MARK: Variables
    var chosenTeam : Team?
    var cancelBlock : (() -> Void)?
    var gameDate : NSDate?
    
    //MARK: Outlets
    @IBOutlet weak var opponentTeamNameTextField: UITextField!
    @IBOutlet weak var teamPicker: UIPickerView!
    @IBOutlet weak var startGameButtonView: UIView!
    
    override func viewDidLoad() {
        //assigning delegates
        teamPicker.delegate = self
        opponentTeamNameTextField.delegate = self
        
        startGameButtonView.userInteractionEnabled = false
        startGameButtonView.alpha = inactiveAlpha
    }
    
    //MARK: Actions
    @IBAction func todaysDateChanged(sender: UIDatePicker) {
        gameDate = sender.date
    }
    
    @IBAction func startGameButtonPressed(sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        cancelBlock?()
    }
    
    //MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        switch textField {
        case opponentTeamNameTextField:
            return prospectiveText.characters.count <= maxPlayerNameLength
        default:
            return true
        }
        
    }

    
    // MARK: Picker Datasource Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.teamCount()
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let team = model.teamAtIndex(row)
        return team.name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenTeam = model.teamAtIndex(row)
    }
}

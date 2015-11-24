//
//  AddPlayerViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/18/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//
//  All textField manipulation code came from the source listed in the StringUtils.swift file

import UIKit

class AddPlayerViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    let model = Model.sharedInstance
    let numberOfPositions = 4
    let maxPlayerNameLength = 30
    let maxJerseyNumberDigits = 2
    let inactiveAlpha : CGFloat = 0.5
    let activeAlpha : CGFloat = 1.0
    var playerName : String?
    var playerJerseyNumber : String?
    var team : Team?
    var chosenPosition = "Defender"
    var cancelBlock : (() -> Void)?
    
    //MARK: Outlets
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var jerseyNumberTextField: UITextField!
    @IBOutlet weak var positionPicker: UIPickerView!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var addPlayerButtonView: UIView!
    
    override func viewDidLoad() {
        //set delegates
        positionPicker.delegate = self
        playerNameTextField.delegate = self
        jerseyNumberTextField.delegate = self
        
        //only allow the user to enter numbers
        jerseyNumberTextField.keyboardType = UIKeyboardType.DecimalPad
        
        //indicate to the user that they cannot add a player until they choose all fields
        addPlayerButtonView.alpha = inactiveAlpha
        addPlayerButtonView.userInteractionEnabled = false
    }
    
    //MARK: Helper Functions
    //makes sure all fields are filled out
    func updateAddPlayerButton() {
        playerName = playerNameTextField.text
        if !(playerName == "") {
            playerJerseyNumber = jerseyNumberTextField.text
            if !(playerJerseyNumber == "") {
                addPlayerButtonView.alpha = activeAlpha
                addPlayerButtonView.userInteractionEnabled = true
            }
        } else {
            addPlayerButtonView.alpha = inactiveAlpha
            addPlayerButtonView.userInteractionEnabled = false
        }
        
    }
    
    //MARK: Actions
    @IBAction func addPlayerButtonPressed(sender: UIButton) {
        playerName = playerNameTextField.text!
        model.addPlayerWithName(playerName!, team: team!, number: Int(playerJerseyNumber!)!, position: chosenPosition)
        cancelBlock?()
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
        
        updateAddPlayerButton()
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        switch textField {
        case playerNameTextField:
            return prospectiveText.characters.count <= maxPlayerNameLength
        case jerseyNumberTextField:
            let decimalSeparator = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as! String
            return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= maxJerseyNumberDigits
            
        default:
            return true
        }
        
    }
    
    //if all the fields are filled, let the user add the player
    func textFieldDidEndEditing(textField: UITextField) {
        updateAddPlayerButton()
    }
    
    // MARK: Picker Datasource Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfPositions
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let position = model.positionAtIndex(row)
        return position
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenPosition = model.positionAtIndex(row)
        updateAddPlayerButton()
    }

}


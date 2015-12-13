//
//  AddPlayerViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/18/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//
//  All textField manipulation code came from the source listed in the StringUtils.swift file

import UIKit

class AddPlayerViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    let model = Model.sharedInstance
    let numberOfPositions = 4
    let maxPlayerNameLength = 25
    let maxJerseyNumberDigits = 2
    let inactiveAlpha : CGFloat = 0.5
    let activeAlpha : CGFloat = 1.0
    let pickerViewFont = UIFont(name: "Orbitron-Light", size: 20.0)

    var playerName : String!
    var playerJerseyNumber : Int!
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //MARK: Helper Functions
    //makes sure all fields are filled out
    func updateAddPlayerButton() {
        playerName = playerNameTextField.text
        if !(playerName == "") {
            if !(jerseyNumberTextField.text == "") {
                playerJerseyNumber = Int(jerseyNumberTextField.text!)
                //if both fields are populated, show the button
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
        var isUniqueNumber = true
        let players = team!.players!.allObjects as! [Player]
        for player in players {
            let playerNumber = player.jerseyNumber!
            if playerNumber == playerJerseyNumber {
                isUniqueNumber = false
            }
        }
        if isUniqueNumber {
            playerName = playerNameTextField.text!
            model.addPlayerWithName(playerName, team: team!, number: playerJerseyNumber, position: chosenPosition)
            cancelBlock?()
        } else {
            let alert = UIAlertController(title: "A player's number must be unique.", message: "The jersey number \(playerJerseyNumber) is already taken.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let position = model.positionAtIndex(row)
        pickerLabel.text = position
        pickerLabel.font = pickerViewFont
        pickerLabel.backgroundColor = model.majorColorForTeam(team!)
        pickerLabel.textColor = model.minorColorForTeam(team!)
        pickerLabel.textAlignment = .Center
        return pickerLabel
    }

}


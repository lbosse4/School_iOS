//
//  OvertimePromptViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/28/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//
//  All textField manipulation code came from the source listed in the StringUtils.swift file

import UIKit

class OvertimePromptViewController: UIViewController, UITextFieldDelegate{
    
    let no = 0
    let yes = 1
    let maxTimeDigits = 2
    let inactiveAlpha : CGFloat = 0.5
    let activeAlpha : CGFloat = 1.0
    let maxSeconds : Int = 59
    var chosenAnswer : Int = 0
    var answerChosenBlock : ((answer: Int, otMinutes: Int, otSeconds: Int) -> Void)?
    
    //MARK: Outlets
    @IBOutlet weak var overtimeMinutesTextField: UITextField!
    @IBOutlet weak var overtimeSecondsTextField: UITextField!
    @IBOutlet weak var continueButtonView: UIView!
    
    override func viewDidLoad() {
        overtimeSecondsTextField.delegate = self
        overtimeMinutesTextField.delegate = self
        overtimeMinutesTextField.keyboardType = UIKeyboardType.DecimalPad
        overtimeSecondsTextField.keyboardType = UIKeyboardType.DecimalPad
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func checkTextFields(){
        //if textfields are active, and are filled, let the user continue
        if overtimeMinutesTextField.text != "" && chosenAnswer == yes {
            if overtimeSecondsTextField.text != "" {
                //show the continue button as active becuase both text fields are filled out
                continueButtonView.alpha = activeAlpha
                continueButtonView.userInteractionEnabled = true
            }
        } else {
            //Show the continue button because the user does not need to fill out text fields
            if chosenAnswer == no {
                continueButtonView.alpha = activeAlpha
                continueButtonView.userInteractionEnabled = true
            } else {
                //user needs to fill out text fields. Hide contiinue
                continueButtonView.alpha = inactiveAlpha
                continueButtonView.userInteractionEnabled = false
            }
        }
    }
    
    //MARK: Actions
    @IBAction func yesOrNoChosen(sender: UISegmentedControl) {
        //user's decision for overtime
        //show text fields if necessary
        switch sender.selectedSegmentIndex {
        case 0:
            chosenAnswer = no
            overtimeMinutesTextField.hidden = true
            overtimeSecondsTextField.hidden = true
        case 1:
            chosenAnswer = yes
            overtimeMinutesTextField.hidden = false
            overtimeSecondsTextField.hidden = false
            
        default:
            break
        }
        
        //show continue nbutton if text fields are filled out
        checkTextFields()
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        if chosenAnswer == yes {
            //used as time fields for overtime
            let otMin = Int(overtimeMinutesTextField.text!)!
            let otSec = Int(overtimeSecondsTextField.text!)!
            
            //make sure seconds are valid
            if otSec > maxSeconds {
                let alert = UIAlertController(title: "Invalid Seconds", message: "Overtime seconds must be less than \(maxSeconds + 1)", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                answerChosenBlock?(answer: chosenAnswer, otMinutes: otMin, otSeconds: otSec)
            }
        } else {
            answerChosenBlock?(answer: chosenAnswer, otMinutes: 0, otSeconds: 0)
        }
        
    }
    
    //MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //see string utils file for documentation
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // We still return true to allow the change to take place.
        if string.characters.count == 0 {
            return true
        }
        
        checkTextFields()
        
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        switch textField {
        case overtimeMinutesTextField:
            let decimalSeparator = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as! String
            return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= maxTimeDigits
        case overtimeSecondsTextField:
            let decimalSeparator = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as! String
            return prospectiveText.isNumeric() &&
                prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                prospectiveText.characters.count <= maxTimeDigits
            
        default:
            return true
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkTextFields()
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

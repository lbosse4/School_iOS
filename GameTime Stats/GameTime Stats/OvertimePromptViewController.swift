//
//  OvertimePromptViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/28/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

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
    }
    
    func checkTextFields(){
        //if textfields are active, and are filled, let the user continue
        if overtimeMinutesTextField.text != "" && chosenAnswer == yes {
            if overtimeSecondsTextField.text != "" {
                continueButtonView.alpha = activeAlpha
                continueButtonView.userInteractionEnabled = true
            }
        } else {
            if chosenAnswer == no {
                continueButtonView.alpha = activeAlpha
                continueButtonView.userInteractionEnabled = true
            } else {
                continueButtonView.alpha = inactiveAlpha
                continueButtonView.userInteractionEnabled = false
            }
        }
    }
    
    //MARK: Actions
    @IBAction func yesOrNoChosen(sender: UISegmentedControl) {
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
        
        checkTextFields()
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        if chosenAnswer == yes {
            let otMin = Int(overtimeMinutesTextField.text!)!
            let otSec = Int(overtimeSecondsTextField.text!)!
            
            if otSec > maxSeconds {
                let alert = UIAlertController(title: "Invalid Seconds", message: "Overtime seconds must be less than \(maxSeconds + 1)", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
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

}

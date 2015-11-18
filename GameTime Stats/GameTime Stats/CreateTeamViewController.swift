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
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//
//  AddPlayerViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/18/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    let model = Model.sharedInstance
    let numberOfPositions = 4
    var chosenPosition = ""
    
    //MARK: Outlets
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var jerseyNumberTextField: UITextField!
    @IBOutlet weak var positionPicker: UIPickerView!
    
    override func viewDidLoad() {
        positionPicker.delegate = self
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
    }

}


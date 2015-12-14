//
//  ColorPickerViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    //Third party
    let colorPicker = SwiftHSVColorPicker(frame: CGRectMake(25, 20, 300, 400))
    
    //stores the previous chosen color to display on color wheel
    var previousColor : UIColor?
    var completionBlock : ((chosenColor: UIColor) -> Void)!
    var cancelBlock : (() -> Void)!
    
    @IBOutlet weak var chooseColorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(colorPicker)
        colorPicker.setViewColor(previousColor!)
    }
    
    @IBAction func chooseColorButtonPressed(sender: UIButton) {
        let chosenColor = colorPicker.color
        completionBlock(chosenColor: chosenColor)
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        cancelBlock()
    }
    
}
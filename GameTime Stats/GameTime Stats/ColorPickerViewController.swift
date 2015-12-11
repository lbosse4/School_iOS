//
//  ColorPickerViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    let colorPicker = SwiftHSVColorPicker(frame: CGRectMake(25, 20, 300, 400))
    var previousColor : UIColor?
    var cancelBlock : ((chosenColor: UIColor) -> Void)!
    @IBOutlet weak var chooseColorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(colorPicker)
    }
    
    @IBAction func chooseColorButtonPressed(sender: UIButton) {
        let chosenColor = colorPicker.color
        cancelBlock(chosenColor: chosenColor)
    }
}
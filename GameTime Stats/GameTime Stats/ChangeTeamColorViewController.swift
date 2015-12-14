//
//  ChangeTeamColorViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/13/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ChangeTeamColorViewController: UIViewController {
    let model = Model.sharedInstance
    var team : Team!
    var cancelBlock : (() -> Void)!
    var majorColor : UIColor!
    var minorColor : UIColor!
    
    @IBOutlet weak var playerIconView: UIView!
    @IBOutlet weak var playerIconNumberLabel: UILabel!
    
    override func viewDidLoad() {
        //set views from defaults
        playerIconView.backgroundColor = model.majorColorForTeam(team)
        playerIconNumberLabel.textColor = model.minorColorForTeam(team)
        majorColor = model.majorColorForTeam(team)
        minorColor = model.minorColorForTeam(team)
    }
    
    @IBAction func chooseJerseyColorButtonPressed(sender: UIButton) {
        //allow the user to update the jersey color.
        let colorPickerViewController = storyboard!.instantiateViewControllerWithIdentifier("ColorPickerViewController") as! ColorPickerViewController
        colorPickerViewController.previousColor = model.majorColorForTeam(team)
        colorPickerViewController.completionBlock = {(chosenColor : UIColor) in
            self.dismissViewControllerAnimated(true, completion: nil)
            //update color
            self.majorColor = chosenColor
            self.playerIconView.backgroundColor = chosenColor
        }
        colorPickerViewController.cancelBlock = {() in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(colorPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func chooseNumberColorButtonPressed(sender: UIButton) {
        //allow the user to update the numbers color
        let colorPickerViewController = storyboard!.instantiateViewControllerWithIdentifier("ColorPickerViewController") as! ColorPickerViewController
        colorPickerViewController.previousColor = model.minorColorForTeam(team)
        colorPickerViewController.completionBlock = {(chosenColor : UIColor) in
            self.dismissViewControllerAnimated(true, completion: nil)
            //update color 
            self.minorColor = chosenColor
            self.playerIconNumberLabel.textColor = chosenColor
        }
        colorPickerViewController.cancelBlock = {() in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(colorPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func updateButtonPressed(sender: UIButton) {
        model.updateMajorColorForTeam(team, majorColor: majorColor)
        model.updateMinorColorForTeam(team, minorColor: minorColor)
        cancelBlock()
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        cancelBlock()
    }
}

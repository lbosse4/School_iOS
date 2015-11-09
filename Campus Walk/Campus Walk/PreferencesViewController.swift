//
//  PreferencesViewController.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 11/8/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class PreferencesViewController : UIViewController {
    let model = Model.sharedInstance
    
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var showFavoritesSwitch: UISwitch!
    
    override func viewDidLoad() {
        let prefs = NSUserDefaults.standardUserDefaults()
        let mapType = prefs.stringForKey(UserDefaults.MapType)
        
        switch mapType! {
        case "Standard":
            mapTypeSegmentedControl.selectedSegmentIndex = 0
        case "Satellite":
            mapTypeSegmentedControl.selectedSegmentIndex = 1
        case "Hybrid":
            mapTypeSegmentedControl.selectedSegmentIndex = 2
        default:
            break
        }
        
        showFavoritesSwitch.on = prefs.boolForKey(UserDefaults.ShowFavorites)
        
    }
    
    @IBAction func mapTypeSegmentedControlTriggered(sender: UISegmentedControl) {
        
        let prefs = NSUserDefaults.standardUserDefaults()
       
        switch sender.selectedSegmentIndex {
        case 0:
            prefs.setObject("Standard", forKey: UserDefaults.MapType)
        case 1:
            prefs.setObject("Satellite", forKey: UserDefaults.MapType)
        case 2:
            prefs.setObject("Hybrid", forKey: UserDefaults.MapType)
        default:
            break
        }
        
        prefs.synchronize()
    }
    
    @IBAction func showFavoritesSwitchToggled(sender: UISwitch) {
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setBool(sender.on, forKey: UserDefaults.ShowFavorites)
        prefs.synchronize()
    }
    
    
}
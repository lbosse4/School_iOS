//
//  DirectionsViewController.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 10/25/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import MapKit

protocol GetDirectionsProtocol {
    //func buildingSourceAndDestinationSelected(source:MKAnnotation?, destination:MKAnnotation?)
    func cancelChildViewController()
}

class DirectionsViewController : UIViewController {
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var toFromSegmentedControl: UISegmentedControl!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var locationOrBuildingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var getDirectionsView: UIView!
    
    let model = Model.sharedInstance
    var delegate: GetDirectionsProtocol?
    
    var source : Building?
    var destination : Building?
    var building : Building!
    var isStartingFromBuilding = false
    //var isEndingAtBuilding = false
    
    override func viewDidLoad() {
        if let name = building.title {
            promptLabel.text = " Would you like directions to or from \(name)?"
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.delegate?.cancelChildViewController()
    }
    
    @IBAction func toFromSegmentedControlTriggered(sender: UISegmentedControl) {
        locationOrBuildingSegmentedControl.hidden = false
        responseLabel.hidden = false
        
        switch sender.selectedSegmentIndex {
        //to
        case 0:
            responseLabel.text = "Should the directions start from your \n current location or another building on campus?"
            destination = building
            //isEndingAtBuilding = true
            isStartingFromBuilding = false
        //from
        case 1:
            responseLabel.text = "Should the directions end at your \n current location or another building on campus?"
            source = building
            isStartingFromBuilding = true
        default:
            break
        }
    }
    
    @IBAction func locationOrBuildingSegmentedControlTriggered(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        //location
        case 0:
            if isStartingFromBuilding {
                
            } else {
                
            }
        //building
        case 1:
            if isStartingFromBuilding {
                
            } else {
                
            }
        default:
            break
        }
        getDirectionsView.hidden = false
        getDirectionsButton.hidden = false
    }
    
}

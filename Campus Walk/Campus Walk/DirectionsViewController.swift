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
    func buildingSourceAndDestinationSelected(source:MKAnnotation?, destination:MKAnnotation?)
    func cancelChildViewController()
}

class DirectionsViewController : UIViewController, FindBuildingsProtocol, CLLocationManagerDelegate {
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var toFromSegmentedControl: UISegmentedControl!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var locationOrBuildingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var getDirectionsView: UIView!
    @IBOutlet weak var chooseABuildingButton: UIButton!
    @IBOutlet weak var chooseABuildingView: UIView!
    @IBOutlet weak var directionsConfirmationLabel: UILabel!
    
    let model = Model.sharedInstance
    let deselectIndex : Int = -1
    let locationManager = CLLocationManager()
    var delegate : GetDirectionsProtocol?
    var chosenBuildingFromTableView : Building?
    var source : Building?
    var destination : Building?
    var building : Building!
    var isStartingFromBuilding = false
    
    override func viewDidLoad() {
        if let name = building.title {
            promptLabel.text = " Would you like directions to or from \(name)?"
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidAppear(animated: Bool) {
        if CLLocationManager.locationServicesEnabled()  {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }

    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        delegate?.cancelChildViewController()
    }
    
    @IBAction func getDirectionsButtonPressed(sender: UIButton) {
        delegate?.buildingSourceAndDestinationSelected(source, destination: destination)
    }
    
    @IBAction func toFromSegmentedControlTriggered(sender: UISegmentedControl) {
        locationOrBuildingSegmentedControl.hidden = false
        responseLabel.hidden = false
        switch sender.selectedSegmentIndex {
        //to
        case 0:
            responseLabel.text = "Should the directions start from your current location or another building on campus?"
            destination = building
            isStartingFromBuilding = false
        //from
        case 1:
            responseLabel.text = "Should the directions end at your current location or another building on campus?"
            source = building
            isStartingFromBuilding = true
        default:
            break
        }
        updateDirectionsConfirmationLabel()
        directionsConfirmationLabel.hidden = true
        locationOrBuildingSegmentedControl.selectedSegmentIndex = deselectIndex
        getDirectionsButton.hidden = true
        getDirectionsView.hidden = true
        chooseABuildingButton.hidden = true
        chooseABuildingView.hidden = true
    }
    
    @IBAction func locationOrBuildingSegmentedControlTriggered(sender: UISegmentedControl) {
        directionsConfirmationLabel.hidden = true
        switch sender.selectedSegmentIndex {
        //location
        case 0:
            chooseABuildingButton.hidden = true
            chooseABuildingView.hidden = true
            
            if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                let userLocationBuildingObject = Building(title: "your current location", latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, yearConstructed: 2015, image: UIImage(named: "NoImageAvailable.png")!, favorite: true, subtitle: "")
                if isStartingFromBuilding {
                    destination = userLocationBuildingObject
                } else {
                    source = userLocationBuildingObject
                }
                getDirectionsView.hidden = false
                getDirectionsButton.hidden = false
                updateDirectionsConfirmationLabel()
            } else {
                let alertVC = UIAlertController(
                    title: "Location Services Not Enabled",
                    message: "Sorry, user location services need to be enabled to use this feature.",
                    preferredStyle: .Alert)
                let okAction = UIAlertAction(
                    title: "Okay",
                    style:.Default,
                    handler: nil)
                alertVC.addAction(okAction)
                presentViewController(alertVC,
                    animated: true,
                    completion: nil)
                getDirectionsButton.hidden = true
                getDirectionsView.hidden = true
            }
            
            
        //building
        case 1:
            chooseABuildingView.hidden = false
            chooseABuildingButton.hidden = false
            getDirectionsButton.hidden = true
            getDirectionsView.hidden = true
            
        default:
            break
        }
        
    }
    @IBAction func chooseABuildingButtonPressed(sender: UIButton) {
        let findBuildingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FindBuildingTableViewController") as! FindBuildingTableViewController
        
        findBuildingViewController.delegate = self
        self.presentViewController(findBuildingViewController, animated: true, completion: nil)
    }

    func findBuildingViewControllerDismissed(chosenBuilding : Building){
        chosenBuildingFromTableView = chosenBuilding
        self.dismissViewControllerAnimated(true, completion: nil)
        getDirectionsView.hidden = false
        getDirectionsButton.hidden = false
        if isStartingFromBuilding {
            destination = chosenBuildingFromTableView
        } else {
            source = chosenBuildingFromTableView
        }
        updateDirectionsConfirmationLabel()
    }
    
    func updateDirectionsConfirmationLabel() {
        if let sourceTitle = source?.title {
            if let destinationTitle = destination?.title {
                directionsConfirmationLabel.text = "Click below for directions to \(destinationTitle) from \(sourceTitle)."
                directionsConfirmationLabel.hidden = false
            }
        }
    }
    
}

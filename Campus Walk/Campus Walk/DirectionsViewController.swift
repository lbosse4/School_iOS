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
    
    let model = Model.sharedInstance
    var delegate: GetDirectionsProtocol?
    
    var source : Building?
    var destination : Building?
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.delegate?.cancelChildViewController()
    }
}

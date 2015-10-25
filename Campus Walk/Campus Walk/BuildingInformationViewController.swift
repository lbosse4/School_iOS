//
//  BuildingInformationViewController.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 10/25/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import MapKit

protocol BuildingInfoProtocol {
    func buildingInfoViewControllerDismissed(response:MKDirectionsResponse?, sourceBuilding : Building, destinationBuilding : Building)
    func cancelChildViewController()
}

class BuildingInformationViewController : UIViewController {
    
    @IBOutlet weak var buildingTitleLabel: UILabel!
    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var buildingYearLabel: UILabel!
    
    var delegate: BuildingInfoProtocol?
    let model = Model.sharedInstance
    var building : Building? = nil
    
    override func viewDidLoad() {
        buildingImageView.image = UIImage(named: (building?.imageName)!)
        buildingImageView.contentMode = UIViewContentMode.ScaleAspectFit
        buildingTitleLabel.text = building?.title
        let yearConstructed = model.yearConstructedForBuildingWithTitle((building?.title)!)
        if yearConstructed != 0{
            buildingYearLabel.text = "Constructed in \(yearConstructed)"
            buildingYearLabel.hidden = false
        } else {
            buildingYearLabel.hidden = true
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        delegate?.cancelChildViewController()
    }
    
    @IBAction func cameraButtonPressed(sender: UIButton) {
        
    }
    
}

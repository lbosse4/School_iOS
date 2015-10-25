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

class BuildingInformationViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var buildingTitleLabel: UILabel!
    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var buildingYearLabel: UILabel!
    
    
    let model = Model.sharedInstance
    let imagePicker = UIImagePickerController()
    var delegate: BuildingInfoProtocol?
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
        imagePicker.delegate = self
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        delegate?.cancelChildViewController()
    }
    
    @IBAction func cameraButtonPressed(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        //imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            buildingImageView.image = pickedImage
            //model.updateImageForBuildingWithTitle(pickedImage.title???, title: building.title)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

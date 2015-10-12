//
//  ContentViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 10/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ContentViewController : UIViewController {
    
    @IBOutlet weak var instructionImageView: UIImageView!
    
    @IBOutlet weak var navigationButton: UIButton!
    
    private var instructionImageName: String?
    private var buttonTitleContent : String?
    let greenColor = UIColor(red: 0.0, green: 0.502, blue: 0.004, alpha: 1.0)
    let model = Model.sharedInstance
    
    var pageIndex: Int?
    
    func configure(pageInstructionImageName : String, buttonTitle : String, index : Int){
        pageIndex = index
        instructionImageName = pageInstructionImageName
        buttonTitleContent = buttonTitle
        
        
    }
    
    override func viewDidLoad() {
        let image = UIImage(named: instructionImageName!)
        instructionImageView.image = image
        instructionImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        navigationButton.setTitle(buttonTitleContent, forState: .Normal)
        navigationButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        if pageIndex == model.numWalkThroughPages - 1 {
            navigationButton.backgroundColor = greenColor
        } else {
            navigationButton.backgroundColor = UIColor.blueColor()
        }
    }
   
//    func configureWithTitle(title:String, flagName:String, info:String, index:Int) {
//        stateIndex = index
//        state  = title
//        flagImage = UIImage(named: flagName)
//        self.info = info
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        titleLabel.text = state
//        flagImageView.image = flagImage
//        infoTextView.text = info
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}








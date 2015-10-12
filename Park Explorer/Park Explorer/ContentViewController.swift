//
//  ContentViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 10/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ContentViewController : UIViewController {
    
    @IBOutlet weak var InstructionImageView: UIImageView!
    
    @IBOutlet weak var navigationButton: UIButton!
    
    private var instructionImageName: String?
    let model = Model.sharedInstance
    
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let instructionImage = UIImage(named: instructionImageName!)
        InstructionImageView.image = instructionImage!
        navigationButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        if pageIndex == Int(model.numberOfWalkThroughPages() - 1){
            navigationButton.setTitle("Continue to Parks!", forState: .Normal)
            navigationButton.backgroundColor = UIColor.blueColor()
        } else {
            navigationButton.setTitle("Next", forState: .Normal)
            navigationButton.backgroundColor = UIColor.greenColor()
        }
    }
    
    func configureWithIndex(index : Int) {
        instructionImageName = "PageInstruction\(index - 1).png"
    }
}








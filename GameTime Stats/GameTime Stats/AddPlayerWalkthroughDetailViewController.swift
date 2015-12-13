//
//  AddPlayerWalkthroughDetailViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/12/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class AddPlayerWalkthroughDetailViewController : UIViewController {
    let model = Model.sharedInstance
    
    private var instructionImageName: String?
    var pageIndex: Int?
    
    @IBOutlet weak var walkthroughImageView: UIImageView!
    
    override func viewDidLoad() {
        let image = UIImage(named: instructionImageName!)
        walkthroughImageView.image = image
        walkthroughImageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func configure(pageInstructionImageName : String, index : Int){
        pageIndex = index
        instructionImageName = pageInstructionImageName
    }
}

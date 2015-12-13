//
//  AddPlayerWalkthroughDetailViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 12/12/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

protocol APWalkthroughCompletedProtocol {
    func dismissMe()
}

class AddPlayerWalkthroughDetailViewController : UIViewController {
    let model = Model.sharedInstance
    let okayFont = UIFont(name: "Orbitron-Medium", size: 34.0)
    let directionFont = UIFont(name: "Orbitron-Medium", size: 20.0)
    
    private var instructionImageName: String?
    var pageIndex: Int?
    var delegate : APWalkthroughCompletedProtocol?
    
    @IBOutlet weak var walkthroughImageView: UIImageView!
    @IBOutlet weak var okayButton: UIButton!
    
    override func viewDidLoad() {
        let image = UIImage(named: instructionImageName!)
        walkthroughImageView.image = image
        walkthroughImageView.contentMode = UIViewContentMode.ScaleAspectFit
        if pageIndex < model.numAPWalkthroughImages() - 1 {
            okayButton.setTitle("Swipe Right to Continue", forState: .Normal)
            okayButton.titleLabel!.font = directionFont
            okayButton.userInteractionEnabled = false
        } else {
            okayButton.setTitle("Okay", forState: .Normal)
            okayButton.titleLabel!.font = okayFont
            okayButton.userInteractionEnabled = true
        }
    }
    
    func configure(pageInstructionImageName : String, index : Int){
        pageIndex = index
        instructionImageName = pageInstructionImageName
    }

    @IBAction func okayButtonPressed(sender: UIButton) {
        delegate?.dismissMe()
    }
    

}

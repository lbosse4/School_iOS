//
//  GameViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class GameViewController : UIViewController {
    let model = Model.sharedInstance
    let darkBlueColor = UIColor(red: 0.01, green: 0.02, blue: 0.78, alpha: 1.0)
    let playerViewSize : CGFloat = 55.0
    let playerViewPaddingWidth : CGFloat = 60.0
    let playerViewMargin : CGFloat = 10.0
    let playerNumberFont = "collegiateHeavyOutline"
    
    var playerViews = [UIView]()
    var testPlayers = [Player]()
    
    @IBOutlet weak var benchContainerView: UIView!
    @IBOutlet weak var fieldImageView: UIImageView!
    
    override func viewDidLoad() {
        testPlayers = model.tstPlayers()
        testPlayers.sortInPlace{(Int($0.jerseyNumber!) < Int($1.jerseyNumber!))}
        fieldImageView.userInteractionEnabled = true
        benchContainerView.userInteractionEnabled = true
        //square.layer.cornerRadius = 1/2 of length
        
        generateViews()
    }
    
    //MARK: Helper Functions
    func generateViews() {
        for player in testPlayers {
            let playerFrame = CGRect(x: playerViewMargin + (playerViewPaddingWidth * CGFloat(player.jerseyNumber!)), y: playerViewMargin, width: playerViewSize, height: playerViewSize)
            let playerView = UIView(frame: playerFrame)
            playerView.backgroundColor = darkBlueColor
            playerView.layer.cornerRadius = playerViewSize/2
            benchContainerView.addSubview(playerView)
            
            let playerNumber = player.jerseyNumber!
            let playerNumberFrame = CGRect(x: 0.0, y: 0.0, width: playerViewSize, height: playerViewSize)
            let playerNumberLabel = UILabel(frame: playerNumberFrame)
            playerNumberLabel.text = "\(playerNumber)"
            playerNumberLabel.font = UIFont(name: playerNumberFont, size: playerViewSize - playerViewMargin/2)
            playerNumberLabel.textColor = UIColor.whiteColor()
            playerNumberLabel.textAlignment = .Center
            playerView.addSubview(playerNumberLabel)
        }
    }
    
    //MARK: Actions
    @IBAction func cancelGameButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}













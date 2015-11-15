//
//  GameViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class GameViewController : UIViewController, UIGestureRecognizerDelegate {
    let model = Model.sharedInstance
    let darkBlueColor = UIColor(red: 0.01, green: 0.02, blue: 0.78, alpha: 1.0)
    let playerViewSize : CGFloat = 55.0
    let playerViewPaddingWidth : CGFloat = 60.0
    let playerViewMargin : CGFloat = 10.0
    let playerNumberFont = "collegiateHeavyOutline"
    let animationDuration : NSTimeInterval = 0.55
    
    var playerViews = [UIView]()
    var currentPlayers = [Player]()
    
    @IBOutlet weak var benchContainerView: UIView!
    @IBOutlet weak var fieldImageView: UIImageView!
    
    override func viewDidLoad() {
        currentPlayers = model.tstPlayers()
        currentPlayers.sortInPlace{(Int($0.jerseyNumber!) < Int($1.jerseyNumber!))}
        fieldImageView.userInteractionEnabled = true
        benchContainerView.userInteractionEnabled = true
        //square.layer.cornerRadius = 1/2 of length
        
        generateViews()
    }
    
    //MARK: Helper Functions
    func generateViews() {
        var loopCounter = 0
        
        for player in currentPlayers {
            let playerFrame = CGRect(x: playerViewMargin + (playerViewPaddingWidth * CGFloat(player.jerseyNumber!)), y: playerViewMargin, width: playerViewSize, height: playerViewSize)
            let playerView = UIView(frame: playerFrame)
            playerView.backgroundColor = darkBlueColor
            playerView.layer.cornerRadius = playerViewSize/2
            playerView.tag = loopCounter
            benchContainerView.addSubview(playerView)
            
            let playerNumber = player.jerseyNumber!
            let playerNumberFrame = CGRect(x: 0.0, y: 0.0, width: playerViewSize, height: playerViewSize)
            let playerNumberLabel = UILabel(frame: playerNumberFrame)
            playerNumberLabel.text = "\(playerNumber)"
            playerNumberLabel.font = UIFont(name: playerNumberFont, size: playerViewSize - playerViewMargin/2)
            playerNumberLabel.textColor = UIColor.whiteColor()
            playerNumberLabel.textAlignment = .Center
            playerView.addSubview(playerNumberLabel)
            
            let panRecognizer = UIPanGestureRecognizer(target: self, action: "panningPlayer:")
            playerView.addGestureRecognizer(panRecognizer)
            
            loopCounter += 1
        }
    }
    
    func checkFieldViewBounds(currentLocation: CGPoint) -> Bool {
        return (currentLocation.x > fieldImageView.bounds.width) || (currentLocation.x < 0) || (currentLocation.y > fieldImageView.bounds.height) || (currentLocation.y < 0)
    }
    
    func resetPlayerView(playerView: UIView) {
        moveView(playerView, toSuperview: benchContainerView)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            let origin = CGPoint(x: self.playerViewMargin + (self.playerViewPaddingWidth * CGFloat(playerView.tag)), y: self.playerViewMargin)
            playerView.frame.origin = origin
        })
        benchContainerView.addSubview(playerView)
    }
    
    func moveView(view:UIView, toSuperview superView: UIView) {
        let newCenter = superView.convertPoint(view.center, fromView: view.superview)
        view.center = newCenter
        superView.addSubview(view)
    }
    
    //MARK: Gesture Recognizers
    func panningPlayer(recognizer: UIGestureRecognizer) {
        if let panningView = recognizer.view {
            fieldImageView.addSubview(panningView)
            let origin = benchContainerView.convertPoint(recognizer.locationInView(fieldImageView), fromView: benchContainerView)
            panningView.center = origin
            
            switch recognizer.state {
            case .Ended:
                let currentLocation = panningView.frame.origin
                if checkFieldViewBounds(currentLocation) {
                    resetPlayerView(panningView)
                } else {
                    
                    
                }
//                if checkBoardViewBounds(currentLocation) {
//                    resetPentominoView(panningImageView, index: index)
//                } else {
//                    let snapOrigin : CGPoint = findSnapCoordinates(currentLocation);
//                    boardImageView.addSubview(panningImageView)
//                    //UIView.animateWithDuration(animationDuration, animations: { () -> Void in
//                    panningImageView.frame.origin = CGPoint(x: snapOrigin.x, y: snapOrigin.y)
//                    //})
//                }

            default:
                break
            }
        }
    }
    
    //MARK: Actions
    @IBAction func cancelGameButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}













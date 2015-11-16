//
//  GameViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

struct playerTime {
    var firstHalfSeconds = 0
    var firstHalfMinutes = 0
    var secondHalfSeconds = 0
    var seconHalfMinutes = 0
}

class GameViewController : UIViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate {
    //Constants
    let model = Model.sharedInstance
    let darkBlueColor = UIColor(red: 0.01, green: 0.02, blue: 0.78, alpha: 1.0)
    let playerViewSize : CGFloat = 55.0
    let playerViewPaddingWidth : CGFloat = 60.0
    let playerViewMargin : CGFloat = 10.0
    let playerNumberFont = "collegiateHeavyOutline"
    let animationDuration : NSTimeInterval = 0.55
    let maxSeconds = 59
    let startingMinutes = 0//30
    let startingSeconds = 03
    let maxScore = 100
    let firstHalf = 1
    let secondHalf = 2
    let formatter = NSNumberFormatter()
    
    //Variables
    var playerViews = [UIView]()
    var playerViewTimers = [NSTimer]()
    var currentPlayers = [Player]()
    var gameTimer = NSTimer()
    var gameTimerMinutes = 0//30
    var gameTimerSeconds = 3//0
    var homeScore = 0
    var guestScore = 0
    var currentHalf = 1
    
    //Outlets
    @IBOutlet weak var benchContainerView: UIView!
    @IBOutlet weak var fieldImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var guestScoreLabel: UILabel!
    @IBOutlet weak var halfLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        currentPlayers = model.tstPlayers()
        
        //for clock - always 2 digits
        formatter.minimumIntegerDigits = 2
        
        //Enable interaction to let the user move the player pieces
        fieldImageView.userInteractionEnabled = true
        benchContainerView.userInteractionEnabled = true
        
        resetButton.hidden = true
        
        generateViews()
    }
    
    //MARK: Helper Functions
    func updateTimer() {
        if gameTimerMinutes == 0 && gameTimerSeconds == 0{
            gameTimer.invalidate()
            updateHalves()
        } else {
            if gameTimerSeconds == 0 {
                gameTimerMinutes--
                gameTimerSeconds = maxSeconds
            } else {
                gameTimerSeconds--
            }
        }
        updateTimerLabel()
    }
    
    func updateHalves(){
        
        if currentHalf == firstHalf {
            currentHalf = secondHalf
            let currentHalfString = formatter.stringFromNumber(currentHalf)!
            halfLabel.text = currentHalfString
            resetButton.setTitle("Second Half", forState: .Normal)
        } else {
            resetButton.setTitle("ViewStats", forState: .Normal)
        }
        resetButton.hidden = false
    }
    
    func updateTimerLabel(){
        //ensure two decimal places
        let minString = formatter.stringFromNumber(gameTimerMinutes)!
        let secString = formatter.stringFromNumber(gameTimerSeconds)!
        //displayCountDown
        timerLabel.text = "\(minString):\(secString)"
    }
    
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
            
            let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "singleTappedPlayer:")
            singleTapRecognizer.numberOfTapsRequired = 1
            playerView.addGestureRecognizer(singleTapRecognizer)
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTappedPlayer:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            playerView.addGestureRecognizer(doubleTapRecognizer)
            
            singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
            
            playerViews.append(playerView)
            loopCounter += 1
        
        }
    }
    
    func checkPopoverFieldViewBounds(currentLocation: CGPoint) -> Bool {
        return (currentLocation.x > fieldImageView.bounds.width) || (currentLocation.x < 0) || (currentLocation.y > fieldImageView.bounds.height) || (currentLocation.y < 0)
    }
    
    func checkFieldViewBounds(currentLocation: CGPoint) -> Bool {
        return (currentLocation.x > fieldImageView.bounds.width - playerViewSize) || (currentLocation.x < 0) || (currentLocation.y > fieldImageView.bounds.height - playerViewSize) || (currentLocation.y < 0)
    }
    
    func resetPlayerView(playerView: UIView) {
        moveView(playerView, toSuperview: benchContainerView)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            let origin = CGPoint(x: self.playerViewMargin + (self.playerViewPaddingWidth * CGFloat(playerView.tag)), y: self.playerViewMargin)
            playerView.frame.origin = origin
        })
        benchContainerView.addSubview(playerView)
        
        //ADD IN STOP TIMER FUNCTION
    }
    
    func moveView(view:UIView, toSuperview superView: UIView) {
        let newCenter = superView.convertPoint(view.center, fromView: view.superview)
        view.center = newCenter
        superView.addSubview(view)
    }
    
    func checkForCollisions(playerView: UIView) {
        for  currentView in playerViews {
            if (CGRectIntersectsRect(playerView.frame, currentView.frame)) && (currentView.tag != playerView.tag) {
                resetPlayerView(currentView)
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .Popover
    }
    
    //MARK: Gesture Recognizers
    func panningPlayer(recognizer: UIPanGestureRecognizer) {
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
                    checkForCollisions(panningView)
                }
            
            case .Cancelled:
                resetPlayerView(panningView)
            default:
                break
            }
        }
    }
    
    func singleTappedPlayer(recognizer: UITapGestureRecognizer) {
        if let tappedView = recognizer.view {
            let currentLocation = recognizer.locationInView(fieldImageView)
            if !checkPopoverFieldViewBounds(currentLocation){
                
                let popoverViewController = storyboard!.instantiateViewControllerWithIdentifier("popoverViewController")
                
                popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
                let popoverContentSize = CGSize(width: 200, height: 250)
                popoverViewController.preferredContentSize = popoverContentSize
                let popoverMenuViewController = popoverViewController.popoverPresentationController
                //maybe update this based on locatoin in fieldView
                popoverMenuViewController!.permittedArrowDirections = .Any
                popoverMenuViewController!.delegate = self
                popoverMenuViewController!.sourceView = tappedView
                popoverMenuViewController?.sourceRect = CGRect(x: playerViewSize/2, y: playerViewSize/2, width: 0.0, height: 0.0)
                
               self.presentViewController(popoverViewController, animated: true, completion: nil)
            }
        }
    }
    
    func doubleTappedPlayer(recognizer: UITapGestureRecognizer) {
        if let tappedView = recognizer.view {
            resetPlayerView(tappedView)
        }
    }
    
    //MARK: Actions
    @IBAction func cancelGameButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func startTimerButtonPressed(sender: UIButton) {
        if !gameTimer.valid {
            gameTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func stopTimerButtonPressed(sender: UIButton) {
        gameTimer.invalidate()
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        gameTimer.invalidate()
        gameTimerSeconds = startingSeconds
        gameTimerMinutes = startingMinutes
        updateTimerLabel()
        resetButton.hidden = true
        resetButton.setTitle("View Stats", forState: .Normal)
    }
    
    @IBAction func homeScorePlusButtonPressed(sender: UIButton) {
        homeScore++
        if homeScore < maxScore {
            let homeScoreString = formatter.stringFromNumber(homeScore)!
            homeScoreLabel.text = homeScoreString
        } else {
            homeScore = maxScore - 1
        }
    }
    
    @IBAction func homeScoreMinusButtonPressed(sender: UIButton) {
        homeScore--
        if homeScore >= 0 {
            let homeScoreString = formatter.stringFromNumber(homeScore)!
            homeScoreLabel.text = homeScoreString
        } else {
            homeScore = 0
        }
    }
    
    @IBAction func guestScorePlusButtonPressed(sender: UIButton) {
        guestScore++
        if guestScore < maxScore {
            let guestScoreString = formatter.stringFromNumber(guestScore)!
            guestScoreLabel.text = guestScoreString
        } else {
            guestScore = maxScore - 1
        }
    }
    
    @IBAction func guestScoreMinusButtonPressed(sender: UIButton) {
        guestScore--
        if guestScore >= 0 {
            let guestScoreString = formatter.stringFromNumber(guestScore)!
            guestScoreLabel.text = guestScoreString
        } else {
            guestScore = 0
        }
    }
    
    
    
}













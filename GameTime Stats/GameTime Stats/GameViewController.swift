//
//  GameViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

//struct playerStat {
//    var firstHalfSeconds = 0
//    var firstHalfMinutes = 0
//    var secondHalfSeconds = 0
//    var secondHalfMinutes = 0
//    var viewTag = 0
//}

class GameViewController : UIViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, cancelGameProtocol {
    //MARK: Constants
    let model = Model.sharedInstance
    let darkBlueColor = UIColor(red: 0.01, green: 0.02, blue: 0.78, alpha: 1.0)
    let playerViewSize : CGFloat = 55.0
    let playerViewPaddingWidth : CGFloat = 65.0
    let playerViewPaddingHeight : CGFloat = 65.0
    let playerViewMargin : CGFloat = 10.0
    let numPlayersThatfit = 11
    let playerNumberFont = "collegiateHeavyOutline"
    let popoverContentSize = CGSize(width: 350, height: 470)
    let animationDuration : NSTimeInterval = 0.55
    let maxSeconds = 59
    let startingMinutes = 0//30
    let startingSeconds = 10
    let maxScore = 100
    let firstHalf = 1
    let secondHalf = 2
    let formatter = NSNumberFormatter()
    let benchContainerHeight : CGFloat = 150.0
    let benchContainerWidth : CGFloat = 756.0
    
    //MARK: Variables
    var playerViews = [UIView]()
    var currentPlayers = [Player]()
    var gameTimer = NSTimer()
    var playersPerRow : Int = 0
    var gameTimerMinutes = 0//30
    var gameTimerSeconds = 10
    var homeScore = 0
    var guestScore = 0
    var currentPeriod = PeriodType.FirstHalf
    var cancelBlock : (() -> Void)?
    var isInitialLoad = true
    var currentGame : Game?
    var currentTeam : Team?
    
    //MARK: Outlets
    @IBOutlet weak var fieldImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var guestScoreLabel: UILabel!
    @IBOutlet weak var halfLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var benchScrollview: UIScrollView!
    
    override func viewDidLoad() {
        //Extract team for current game
        //TODO: CHANGE THIS TO EXTRACT BASED ON CORRECT TEAM NAME
        
        
        //for clock - always 2 digits
        formatter.minimumIntegerDigits = 2
        
        //Enable interaction to let the user move the player pieces
        fieldImageView.userInteractionEnabled = true
        benchScrollview.userInteractionEnabled = true
        
        resetButton.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        if isInitialLoad {
            performSegueWithIdentifier("gameInfoSegue", sender: self)
            isInitialLoad = false
        }
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
        if currentPeriod == PeriodType.FirstHalf {
            currentPeriod = PeriodType.SecondHalf
            halfLabel.text = currentPeriod
            resetButton.setTitle(PeriodType.SecondHalf, forState: .Normal)
        } else {
            resetButton.setTitle("View Stats", forState: .Normal)
        }
        resetButton.hidden = false
        startButton.alpha = 0.5
        startButton.userInteractionEnabled = false
        
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
        playersPerRow = currentPlayers.count/2
        
        //formatting - numPlayersThatFit represents the number of players that fit without scrollview
        if playersPerRow <= numPlayersThatfit {
            playersPerRow = numPlayersThatfit
        }
        let scrollViewWidth = (CGFloat(playersPerRow) * playerViewPaddingWidth) + (playerViewMargin * 2)
        // Allow images to continue off of the screen if there are too many to fit
        if scrollViewWidth > benchContainerWidth {
            benchScrollview.contentSize = CGSize(width: scrollViewWidth, height: benchContainerHeight)
        } else {
            benchScrollview.contentSize = CGSize(width: benchContainerWidth, height: benchContainerHeight)
        }
        
        for player in currentPlayers {
            //margin : padding from the edge of the scrollview
            //paddingWidth: The space needed to correctly space the view, including the width of the view
            
            let playerFrame : CGRect
            
            //Set location of pieces: first statement sets bottom row, second sets top
            if loopCounter + 1 > playersPerRow {
                playerFrame = CGRect(x: playerViewMargin + (playerViewPaddingWidth * CGFloat(loopCounter - playersPerRow)), y: playerViewMargin + playerViewPaddingHeight, width: playerViewSize, height: playerViewSize)
            } else {
                playerFrame = CGRect(x: playerViewMargin + (playerViewPaddingWidth * CGFloat(loopCounter)), y: playerViewMargin, width: playerViewSize, height: playerViewSize)

            }
            
            //create playerView
            let playerView = UIView(frame: playerFrame)
            playerView.backgroundColor = darkBlueColor
            playerView.layer.cornerRadius = playerViewSize/2
            playerView.tag = loopCounter
            benchScrollview.addSubview(playerView)
            
            //add player jersey number
            let playerNumber = player.jerseyNumber!
            let playerNumberFrame = CGRect(x: 0.0, y: 0.0, width: playerViewSize, height: playerViewSize)
            let playerNumberLabel = UILabel(frame: playerNumberFrame)
            playerNumberLabel.text = "\(playerNumber)"
            playerNumberLabel.font = UIFont(name: playerNumberFont, size: playerViewSize - playerViewMargin)
            playerNumberLabel.textColor = UIColor.whiteColor()
            playerNumberLabel.textAlignment = .Center
            playerView.addSubview(playerNumberLabel)
            
            //Add playerView recongnizers
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
    
    func addStatsObjects(){
        for player in currentPlayers {
            model.addStatsObject(player, game: currentGame!, currentPeriod: currentPeriod)
        }
    }
    
    //makes sure that the current location is within the bounds of the field
    //padding works for edge cases for player views - not needed for the popover view.
    func checkFieldViewBounds(currentLocation: CGPoint, padding : CGFloat) -> Bool {
        return (currentLocation.x > fieldImageView.bounds.width - padding) || (currentLocation.x < 0) || (currentLocation.y > fieldImageView.bounds.height - padding) || (currentLocation.y < 0)
    }
    
    func resetPlayerView(playerView: UIView) {
        moveView(playerView, toSuperview: benchScrollview)
        
        var origin : CGPoint
        
        
        
        if playerView.tag + 1 > playersPerRow {
            origin = CGPoint(x: playerViewMargin + (playerViewPaddingWidth * CGFloat(playerView.tag - playersPerRow)), y: playerViewMargin + playerViewPaddingHeight)
        } else {
            origin = CGPoint(x: playerViewMargin + (playerViewPaddingWidth * CGFloat(playerView.tag)), y: playerViewMargin)
            
        }
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            playerView.frame.origin = origin
            }) { (finished) -> Void in
                self.benchScrollview.addSubview(playerView)
        }
        
        //TODO: ADD IN STOP TIMER FUNCTION
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
    
    //present the stats editor as a popover
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .Popover
    }
    
    func dismissMe() {
        cancelBlock?()
    }
    
    //MARK: Gesture Recognizers
    func panningPlayer(recognizer: UIPanGestureRecognizer) {
        if let panningView = recognizer.view {
            //view.bringSubviewToFront(fieldImageView)
            //fieldImageView.bringSubviewToFront(panningView)
            fieldImageView.addSubview(panningView)
            let origin = benchScrollview.convertPoint(recognizer.locationInView(fieldImageView), fromView: benchScrollview)
            panningView.center = origin
            
            switch recognizer.state {
            case .Ended:
                let currentLocation = panningView.frame.origin
                if checkFieldViewBounds(currentLocation, padding: playerViewSize) {
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
            if !checkFieldViewBounds(currentLocation, padding: 0.0){
                
                let navPopoverViewController = storyboard!.instantiateViewControllerWithIdentifier("popoverViewController") as! UINavigationController
                let popoverViewController = navPopoverViewController.viewControllers[0] as! StatEditorTableViewController
                
                navPopoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
                
                popoverViewController.preferredContentSize = popoverContentSize
                let popoverMenuViewController = navPopoverViewController.popoverPresentationController
                //maybe update this based on locatoin in fieldView
                popoverMenuViewController!.permittedArrowDirections = .Any
                popoverMenuViewController!.delegate = self
                popoverMenuViewController!.sourceView = tappedView
                popoverMenuViewController?.sourceRect = CGRect(x: playerViewSize/2, y: playerViewSize/2, width: 0.0, height: 0.0)
                
                popoverViewController.cancelBlock = {() in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                popoverViewController.player = currentPlayers[recognizer.view!.tag]
                popoverViewController.period = currentPeriod
                
                self.presentViewController(navPopoverViewController, animated: true, completion: nil)
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
        //TODO: Delete Game object here
        //TODO: Delete all stats objects too??
        cancelBlock?()
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
        if resetButton.titleForState(.Normal) == "Second Half" {
            gameTimer.invalidate()
            gameTimerSeconds = startingSeconds
            gameTimerMinutes = startingMinutes
            updateTimerLabel()
            resetButton.hidden = true
            resetButton.setTitle("View Stats", forState: .Normal)
            startButton.alpha = 1.0
            startButton.userInteractionEnabled = true
        } else {
            //TODO: ADD STATS OVERVIEW VIEWCONTROLLER HERE
        }
        
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
    
    //MARK: prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "gameInfoSegue":
            let gameSetupController = segue.destinationViewController as! GameSetupViewController
            gameSetupController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            gameSetupController.saveBlock = { (game: Game, team: Team) in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.currentGame = game
                self.currentTeam = team
                self.currentPlayers = self.model.playersForTeam(self.currentTeam!)
                self.generateViews()
            }
            
            gameSetupController.delegate = self
        default:
            break
        }
    }
    
}













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
    let popoverContentSize = CGSize(width: 350.0, height: 470.0)
    let formSheetContentSize = CGSize(width: 350.0, height: 400.0)
    let animationDuration : NSTimeInterval = 0.55
    let maxSeconds = 59
    let startingMinutes = 0//30
    let startingSeconds = 3
    let maxScore = 100
    let firstHalf = 1
    let secondHalf = 2
    let overtimeString = "OT"
    let formatter = NSNumberFormatter()
    let benchContainerHeight : CGFloat = 150.0
    let benchContainerWidth : CGFloat = 756.0
    let no = 0
    let yes = 1
    let activeAlpha : CGFloat = 1.0
    let inactiveAlpha : CGFloat = 0.5
    
    //MARK: Variables
    var playerViews = [UIView]()
    var isPlayerAtIndexOnField = [Bool]()
    var currentPlayers = [Player]()
    var gameTimer = NSTimer()
    var playersPerRow : Int = 0
    var gameTimerMinutes = 0//30
    var gameTimerSeconds = 3
    var homeScore = 0
    var guestScore = 0
    var currentPeriod = PeriodType.FirstHalf
    var cancelBlock : (() -> Void)?
    var isInitialLoad = true
    var currentGame : Game!
    var currentTeam : Team!
    var overtimeChosenAnswer : Int?
    var overtimeMinutes : Int?
    var overtimeSeconds : Int?
    var shouldShowStatsEditor = true

    
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
            shouldShowStatsEditor = false
            updateHalves()
            //make sure all of the data is saved
            model.saveDMContext()
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
        var loopCounter = 0
        for player in currentPlayers {
            if isPlayerAtIndexOnField[loopCounter] {
                let currentSecondsLeft = calculateSecondsLeft()
                let playerStats = model.statsForPlayer(player, game: currentGame, periodType: currentPeriod)
                let timeElapsed = Int(playerStats.secondsLeftAtEnter!) - currentSecondsLeft
                playerStats.secondsPlayed = Int(playerStats.secondsPlayed!) + timeElapsed
            
            }
            
            loopCounter++
        }
        
        switch currentPeriod {
        case PeriodType.FirstHalf:
            //set the new period
            currentPeriod = PeriodType.SecondHalf
            
            //set the half indicator
            let secondHalfString = formatter.stringFromNumber(secondHalf)
            halfLabel.text = secondHalfString
            
            resetButton.setTitle(PeriodType.SecondHalf, forState: .Normal)
            
            let secondHalfPromptViewController = storyboard!.instantiateViewControllerWithIdentifier("SecondHalfPromptViewController") as! SecondHalfPromptViewController
            secondHalfPromptViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            secondHalfPromptViewController.preferredContentSize = formSheetContentSize
            secondHalfPromptViewController.cancelBlock = {() in
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.gameTimer.invalidate()
                    self.gameTimerSeconds = self.startingSeconds
                    self.gameTimerMinutes = self.startingMinutes
                    self.updateTimerLabel()
                    //resetButton.hidden = true
                    //startButton.alpha = activeAlpha
                    self.startButton.alpha = self.activeAlpha
                    self.startButton.userInteractionEnabled = true
                    
                    self.addStatsObjects()
                    
                    var loopCounter = 0
                    for player in self.currentPlayers {
                        if self.isPlayerAtIndexOnField[loopCounter]{
                            let currentSecondsLeft = self.calculateSecondsLeft()
                            let playerStats = self.model.statsForPlayer(player, game: self.currentGame, periodType: self.currentPeriod)
                            playerStats.secondsLeftAtEnter = currentSecondsLeft
                        }
                        loopCounter++
                    }

                })
            }
            
            presentViewController(secondHalfPromptViewController, animated: true, completion: nil)
            
        case PeriodType.SecondHalf:
            //resetButton.setTitle("View Stats", forState: .Normal)
            let overtimePromptController = storyboard!.instantiateViewControllerWithIdentifier("OvertimePromptViewController") as! OvertimePromptViewController
            overtimePromptController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            overtimePromptController.preferredContentSize = formSheetContentSize
            
            
            //Asks the user if there will be overtime.
            //If there is overtime (yes)
            overtimePromptController.answerChosenBlock = {(answer: Int, otMinutes: Int, otSeconds: Int) in
                self.overtimeChosenAnswer = answer
                self.dismissViewControllerAnimated(true, completion: nil)
                if answer == self.yes {
                    self.currentPeriod = PeriodType.Overtime
                    self.resetButton.setTitle(PeriodType.Overtime, forState: .Normal)
                    self.halfLabel.text = self.overtimeString
                    self.overtimeMinutes = otMinutes
                    self.overtimeSeconds = otSeconds
                    self.currentGame!.hasOvertime = true
                } else {
                    self.resetButton.setTitle("View Stats", forState: .Normal)
                    self.currentGame!.hasOvertime = false
                }
            }
            
            self.presentViewController(overtimePromptController, animated: true, completion: nil)
            
        case PeriodType.Overtime:
            resetButton.setTitle("View Stats", forState: .Normal)
        default: break
        }
        
        resetButton.hidden = false
        startButton.alpha = inactiveAlpha
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
            
            singleTapRecognizer.delegate = self
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTappedPlayer:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            playerView.addGestureRecognizer(doubleTapRecognizer)
            
            singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
            
            isPlayerAtIndexOnField.append(false)
            playerViews.append(playerView)
            loopCounter += 1
        
        }
    }
    
    func addStatsObjects(){
        shouldShowStatsEditor = true
        for player in currentPlayers {
            model.addStatsObject(player, game: currentGame!, currentPeriod: currentPeriod)
        }
    }
    
    func calculateSecondsLeft() -> Int {
        //converts minutes to seconds, maxSeconds is one less than the number of seconds in a minute
        return gameTimerMinutes*(maxSeconds + 1) + gameTimerSeconds
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
        
        if isPlayerAtIndexOnField[playerView.tag] {
            let currentSecondsLeft = calculateSecondsLeft()
            let playerStats = model.statsForPlayer(currentPlayers[playerView.tag], game: currentGame, periodType: currentPeriod)
            let timeElapsed = Int(playerStats.secondsLeftAtEnter!) - currentSecondsLeft
            playerStats.secondsPlayed = Int(playerStats.secondsPlayed!) + timeElapsed
            
        }
    }
    
    //move view's center and superview
    func moveView(view:UIView, toSuperview superView: UIView) {
        let newCenter = superView.convertPoint(view.center, fromView: view.superview)
        view.center = newCenter
        superView.addSubview(view)
    }
    
    //sees if any views are overlapping. If they are, put move the player on the field to the bench (replace with playerView)
    func checkForCollisions(playerView: UIView) {
        for  currentView in playerViews {
            if (CGRectIntersectsRect(playerView.frame, currentView.frame)) && (currentView.tag != playerView.tag) {
                resetPlayerView(currentView)
                isPlayerAtIndexOnField[currentView.tag] = false
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
                    isPlayerAtIndexOnField[panningView.tag] = false
                } else {
                    if !isPlayerAtIndexOnField[panningView.tag] {
//                        let currentTime = NSDate()
//                        let playerStats = model.statsForPlayer(currentPlayers[panningView.tag], game: currentGame!, periodType: currentPeriod)
//                        playerStats.enterTime = currentTime
                        let currentSecondsLeft = calculateSecondsLeft()
                        let playerStats = model.statsForPlayer(currentPlayers[panningView.tag], game: currentGame, periodType: currentPeriod)
                        playerStats.secondsLeftAtEnter = currentSecondsLeft
                    }
                    checkForCollisions(panningView)
                    isPlayerAtIndexOnField[panningView.tag] = true
                }
            
            case .Cancelled:
                resetPlayerView(panningView)
                isPlayerAtIndexOnField[panningView.tag] = false

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
                popoverViewController.game = currentGame
                
                
                self.presentViewController(navPopoverViewController, animated: true, completion: nil)
            }
        }
    }
    
    func doubleTappedPlayer(recognizer: UITapGestureRecognizer) {
        if let tappedView = recognizer.view {
            resetPlayerView(tappedView)
            isPlayerAtIndexOnField[tappedView.tag] = false
        }
    }
    
    //MARK: Actions
    @IBAction func cancelGameButtonPressed(sender: UIButton) {
        model.deleteGame(currentGame!)
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
        switch resetButton.titleForState(.Normal)! {
        case PeriodType.SecondHalf:
            //TODO: THIS CODE IS REPLICATEd IN THE SECOND HALF PROMPT. FIND A WAY TO CONDENSE (basically, don't have it here.)
            //CHECK IF THE TIMER RAN OUT AND ITS THE SECOND HALF IN THE COMPLETEION BLOCK OF YOUR STATS VIEW CONTROLLER CODE
            gameTimer.invalidate()
            gameTimerSeconds = startingSeconds
            gameTimerMinutes = startingMinutes
            updateTimerLabel()
            resetButton.hidden = true
            startButton.alpha = activeAlpha
            startButton.userInteractionEnabled = true
            addStatsObjects()
            
            var loopCounter = 0
            for player in currentPlayers {
                if isPlayerAtIndexOnField[loopCounter]{
                    let currentSecondsLeft = calculateSecondsLeft()
                    let playerStats = model.statsForPlayer(player, game: currentGame, periodType: currentPeriod)
                    playerStats.secondsLeftAtEnter = currentSecondsLeft
                }
                loopCounter++
            }
            
        case PeriodType.Overtime:
            //TODO: move this to cancel of overtime prompt
            gameTimer.invalidate()
            gameTimerMinutes = overtimeMinutes!
            gameTimerSeconds = overtimeSeconds!
            updateTimerLabel()
            resetButton.hidden = true
            startButton.alpha = activeAlpha
            startButton.userInteractionEnabled = true
            addStatsObjects()
        case "View Stats":
            //TODO: ADD STATS OVERVIEW VIEWCONTROLLER HERE
            cancelBlock!()
        default:
            break
        }
        
        //shouldShowStatsEditor = true
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
    
    //MARK: Recognizer Delegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        //TODO: Make sure THIS IS WORKING
        if shouldShowStatsEditor {
            return true
        } else {
            return false
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
                self.addStatsObjects()
                
            }
            
            gameSetupController.delegate = self
        default:
            break
        }
    }
}













//
//  GameViewController.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class GameViewController : UIViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, cancelGameProtocol, TeamStatsViewedProtocol {
    //MARK: Constants
    let model = Model.sharedInstance
    let playerViewSize : CGFloat = 55.0
    let playerViewPaddingWidth : CGFloat = 65.0
    let playerViewPaddingHeight : CGFloat = 65.0
    let playerViewMargin : CGFloat = 10.0
    let numPlayersThatfit = 11
    let playerNumberFont = "collegiateHeavyOutline"
    let popoverContentSize = CGSize(width: 350.0, height: 470.0)
    let formSheetContentSize = CGSize(width: 350.0, height: 400.0)
    let statSummaryContentSize = CGSize(width: 600.0, height: 800.0)
    let animationDuration : NSTimeInterval = 0.55
    let maxSeconds = 59
    let startingMinutes = 30
    let startingSeconds = 0//3
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
    let secondsInterval : NSTimeInterval = 0.05 //1.0
    
    //MARK: Variables
    var playerViews = [UIView]()
    var isPlayerAtIndexOnField = [Bool]()
    var currentPlayers = [Player]()
    var gameTimer = NSTimer()
    var playersPerRow : Int = 0
    var gameTimerMinutes = 30
    var gameTimerSeconds = 0//3
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
    var isPresentingStatsEditor = false

    
    //MARK: Outlets
    @IBOutlet weak var fieldImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var guestScoreLabel: UILabel!
    @IBOutlet weak var halfLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var benchScrollview: UIScrollView!
    
    override func viewDidLoad() {
        
        //for clock - always 2 digits
        formatter.minimumIntegerDigits = 2
        
        //Enable interaction to let the user move the player pieces
        fieldImageView.userInteractionEnabled = true
        benchScrollview.userInteractionEnabled = true
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
            //TODO: MAKE SURE STATS ARE ORGANIZED
            //TODO: FIX STAT TIME PLAYED ERROR
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
            //set the half indicator
            let secondHalfString = formatter.stringFromNumber(secondHalf)
            halfLabel.text = secondHalfString
            
            presentSecondHalfPromptViewController()
            
        case PeriodType.SecondHalf:
            presentOvertimePromptViewController()
            
        case PeriodType.Overtime:
            presentTeamStatsSummaryViewController()
        default: break
        }
        
        startButton.alpha = inactiveAlpha
        startButton.userInteractionEnabled = false
        
    }
    
    func presentSecondHalfPromptViewController(){
        let secondHalfPromptViewController = storyboard!.instantiateViewControllerWithIdentifier("SecondHalfPromptViewController") as! SecondHalfPromptViewController
        secondHalfPromptViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        secondHalfPromptViewController.preferredContentSize = formSheetContentSize
        secondHalfPromptViewController.cancelBlock = {() in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.gameTimer.invalidate()
                self.currentPeriod = PeriodType.SecondHalf
                self.gameTimerSeconds = self.startingSeconds
                self.gameTimerMinutes = self.startingMinutes
                self.updateTimerLabel()
                self.startButton.alpha = self.activeAlpha
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
        if !isPresentingStatsEditor {
            presentViewController(secondHalfPromptViewController, animated: true, completion: nil)
        }

    }
    
    func presentOvertimePromptViewController(){
        let overtimePromptController = storyboard!.instantiateViewControllerWithIdentifier("OvertimePromptViewController") as! OvertimePromptViewController
        overtimePromptController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        overtimePromptController.preferredContentSize = formSheetContentSize
        
        
        //Asks the user if there will be overtime.
        //If there is overtime (yes)
        overtimePromptController.answerChosenBlock = {(answer: Int, otMinutes: Int, otSeconds: Int) in
            self.currentPeriod = PeriodType.Overtime
            if answer == self.yes {
                //change to overtime
                self.halfLabel.text = self.overtimeString
                self.overtimeMinutes = otMinutes
                self.overtimeSeconds = otSeconds
                self.currentGame!.hasOvertime = true
                
                self.overtimeChosenAnswer = answer
                self.gameTimer.invalidate()
                self.gameTimerMinutes = otMinutes
                self.gameTimerSeconds = otSeconds
                self.updateTimerLabel()
                self.startButton.alpha = self.activeAlpha
                self.startButton.userInteractionEnabled = true
                self.addStatsObjects()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.currentGame!.hasOvertime = false
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.presentTeamStatsSummaryViewController()
                })
            }
            
        }
        
        if !isPresentingStatsEditor {
            self.presentViewController(overtimePromptController, animated: true, completion: nil)
        }
        
    }
    
    func presentTeamStatsSummaryViewController() {
        currentGame.homeScore = homeScore
        currentGame.guestScore = guestScore
        let teamStatsSummaryViewController = storyboard!.instantiateViewControllerWithIdentifier("TeamStatsViewController") as! TeamStatsViewController
        teamStatsSummaryViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        teamStatsSummaryViewController.preferredContentSize = statSummaryContentSize
        teamStatsSummaryViewController.team = currentTeam
        teamStatsSummaryViewController.game = currentGame
        teamStatsSummaryViewController.delegate = self
        teamStatsSummaryViewController.cancelBlock = {() in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if !isPresentingStatsEditor {
            self.presentViewController(teamStatsSummaryViewController, animated: true, completion: nil)
        }
        
    }
    
    func presentStatsEditorViewController(tappedView: UIView){
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
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.isPresentingStatsEditor = false
                //if the first half is over, and the stats view controller was up, present the second half option when they close it.
                if self.gameTimerMinutes == 0 && self.gameTimerSeconds == 0 {
                    switch self.currentPeriod {
                    case PeriodType.FirstHalf:
                        self.presentSecondHalfPromptViewController()
                        
                    case PeriodType.SecondHalf:
                        self.presentOvertimePromptViewController()
                    case PeriodType.Overtime:
                        self.presentTeamStatsSummaryViewController()
                    default:
                        break
                    }
                }
            })
        }
        
        popoverViewController.player = currentPlayers[tappedView.tag]
        popoverViewController.period = currentPeriod
        popoverViewController.game = currentGame
        
        self.presentViewController(navPopoverViewController, animated: true, completion: nil)
        isPresentingStatsEditor = true

    }
    
    
    func updateTimerLabel(){
        //ensure two decimal places
        let minString = formatter.stringFromNumber(gameTimerMinutes)!
        let secString = formatter.stringFromNumber(gameTimerSeconds)!
        //displayCountDown
        timerLabel.text = "\(minString):\(secString)"
    }
    
    //returns true if value is odd
    func isOdd(value : Int) -> Bool {
        
        if value % 2 == 0 {
            return false
        } else {
            return true
        }
    }
    
    func generateViews() {
        var loopCounter = 0
        playersPerRow = currentPlayers.count/2
        
        //formatting - numPlayersThatFit represents the number of players that fit without scrollview
        if playersPerRow <= numPlayersThatfit {
            playersPerRow = numPlayersThatfit
        } else {
            //if the scroll function is needed, and the count per row is odd, we want the extra view to appear in the first row, not the second
            if isOdd(currentPlayers.count) {
                playersPerRow++
            }
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
            playerView.layer.cornerRadius = playerViewSize/2
            playerView.tag = loopCounter
            let viewColor : UIColor = model.majorColorForTeam(currentTeam)
            playerView.backgroundColor = viewColor
            benchScrollview.addSubview(playerView)
            
            //add player jersey number
            let playerNumber = player.jerseyNumber!
            let playerNumberFrame = CGRect(x: 0.0, y: 0.0, width: playerViewSize, height: playerViewSize)
            let playerNumberLabel = UILabel(frame: playerNumberFrame)
            playerNumberLabel.text = "\(playerNumber)"
            playerNumberLabel.font = UIFont(name: playerNumberFont, size: playerViewSize - playerViewMargin)
            playerNumberLabel.textColor = model.minorColorForTeam(currentTeam)
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
        for player in currentPlayers {
            model.addStatsObject(player, game: currentGame!, currentPeriod: currentPeriod)
        }
        shouldShowStatsEditor = true
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
        
        fieldImageView.bringSubviewToFront(playerView)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            playerView.frame.origin = origin
            }) { (finished) -> Void in
                self.benchScrollview.addSubview(playerView)
        }
        
//        UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
//            playerView.frame.origin = origin
//            
//            }) { (finished : Bool) -> Void in
//                self.benchScrollview.addSubview(playerView)
//        }
        
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
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
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
    
    @IBAction func resetPlayersButtonPressed(sender: UIButton) {
        for playerView in playerViews {
            resetPlayerView(playerView)
        }
    }
    
    func singleTappedPlayer(recognizer: UITapGestureRecognizer) {
        if let tappedView = recognizer.view {
            let currentLocation = recognizer.locationInView(fieldImageView)
            if !checkFieldViewBounds(currentLocation, padding: 0.0){
                presentStatsEditorViewController(tappedView)
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
            gameTimer = NSTimer.scheduledTimerWithTimeInterval(secondsInterval, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        }
        
    }
    
    @IBAction func stopTimerButtonPressed(sender: UIButton) {
        gameTimer.invalidate()
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













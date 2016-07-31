//
//  ViewController.swift
//  Multiplication Exercises
//
//  Created by Lauren Bosse on 8/30/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let multiplicationArgsUpperBound: UInt32 = 16
    let numRoundsInGame = 10
    let allowedDistanceFromRightAnswer: UInt32 = 5
    let numPositiveOrNegativeOptions: UInt32 = 2
    
    var roundNumber = 0
    var numQuestionsCorrect = 0
    var randomMultiplicandValue : UInt32 = 0
    var randomMultiplierValue :UInt32 = 0
    var currentAnswer = 0
    var userSelectedAnswer = 0
    var currentStartButtonState = startButtonOptions.Start
    
    var answerChoicesArray = [0,0,0,0]
    
    enum startButtonOptions: String{
        case Restart = "Restart"
        case Start = "Start"
        case Next = "Next"
    }
    
    @IBOutlet weak var multiplicandLabel: UILabel!
    @IBOutlet weak var multiplierLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var horizontalLineLabel: UILabel!
    @IBOutlet weak var multiplicationSymbolLabel: UILabel!
    @IBOutlet weak var answerChoicesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var correctAnswerProgressLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var directionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        multiplicandLabel.hidden = true
        multiplierLabel.hidden = true
        answerLabel.hidden = true
        horizontalLineLabel.hidden = true
        multiplicationSymbolLabel.hidden = true
        answerChoicesSegmentedControl.hidden = true
        correctAnswerProgressLabel.hidden = true
        answerLabel.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(sender: AnyObject) {
        startButton.hidden = true
        answerLabel.hidden = true
        directionLabel.textColor = UIColor.blackColor()
        
        switch currentStartButtonState {
        case .Restart:
            currentStartButtonState = startButtonOptions.Start
            startButton.setTitle("Start", forState: .Normal)
            numQuestionsCorrect = 0
            correctAnswerProgressLabel.hidden = true
            fallthrough
            
        case .Start:
            currentStartButtonState = startButtonOptions.Next
            startButton.setTitle("Next", forState: .Normal)
            fallthrough 
            
        case .Next:
            directionLabel.text = "Pick correct answer."
            
            generateMultiplicationArgs()
            currentAnswer = Int(randomMultiplicandValue * randomMultiplierValue)
            populateSegmentedControlAnswerChoices(currentAnswer)
            answerChoicesSegmentedControl.hidden = false
            break
            
        default:
            break
        }
        
    }
    
    //called when user chooses an answer
    @IBAction func answerChoiceIndexChanged(sender: UISegmentedControl) {
        let currentSelectedAnswerIndex = answerChoicesSegmentedControl.selectedSegmentIndex
        userSelectedAnswer = answerChoicesArray[currentSelectedAnswerIndex]
        
        //deselect and hide all segments
        answerChoicesSegmentedControl.selectedSegmentIndex = -1
        answerChoicesSegmentedControl.hidden = true
        
        if userSelectedAnswer == currentAnswer {
            directionLabel.text = "Correct! Great Job."
            directionLabel.textColor = UIColor(red: 0.0, green: 0.502, blue: 0.004, alpha: 1.0)
            numQuestionsCorrect++
        } else {
            directionLabel.text = "Incorrect."
            directionLabel.textColor = UIColor.redColor()
        }
        
        updateProgressLabel()
        resetStartButton()
        answerLabel.text = "\(currentAnswer)"
        answerLabel.hidden = false
    }
    
    
    func generateMultiplicationArgs() {
        randomMultiplicandValue = arc4random_uniform(multiplicationArgsUpperBound)
        randomMultiplierValue = arc4random_uniform(multiplicationArgsUpperBound)
        
        multiplicandLabel.text = "\(randomMultiplicandValue)"
        multiplierLabel.text = "\(randomMultiplierValue)"
        
        multiplicandLabel.hidden = false
        multiplierLabel.hidden = false
        multiplicationSymbolLabel.hidden = false
        horizontalLineLabel.hidden = false
    }
    
    func populateSegmentedControlAnswerChoices(answer: Int) {
        answerChoicesArray[0] = answer
        for (var i = 1; i < answerChoicesSegmentedControl.numberOfSegments; i++){
            answerChoicesArray[i] = 0
        }
        
        //var loopCounter = 1
        var tempAnswerChoice = 0
        //var tempLoopCounter = 0
        
        for(var i = 1; i < answerChoicesSegmentedControl.numberOfSegments; i++){
            tempAnswerChoice = generateAnswerChoice(currentAnswer)
            
            while (answerChoicesArray.contains(tempAnswerChoice)){
                tempAnswerChoice = generateAnswerChoice(currentAnswer)
            }
            answerChoicesArray[i] = tempAnswerChoice
        }

        answerChoicesArray.shuffle()
        
        for var i = 0; i < answerChoicesSegmentedControl.numberOfSegments; i++ {
            answerChoicesSegmentedControl.setTitle("\(answerChoicesArray[i])", forSegmentAtIndex: i)
        }
    }
    
    func generateAnswerChoice(answer: Int) -> Int {
        
        if answer < Int(allowedDistanceFromRightAnswer) {
            return answer + Int(arc4random_uniform(allowedDistanceFromRightAnswer)) + 1
            
        } else {
            //this variable randomly decides whether the random value is added or subtracted
            let plusOrMinusIndicator = Int(arc4random_uniform(numPositiveOrNegativeOptions))
            
            if plusOrMinusIndicator == 0{
                return answer + Int(arc4random_uniform(allowedDistanceFromRightAnswer)) + 1
            }
            else{
                return answer - Int(arc4random_uniform(allowedDistanceFromRightAnswer)) - 1
            }
        }
    }
    
    func updateProgressLabel(){
        roundNumber++
        correctAnswerProgressLabel.text = "\(numQuestionsCorrect)/\(roundNumber) Questions Correct"
        correctAnswerProgressLabel.hidden = false
    }
    
    func resetStartButton(){
        
        if roundNumber >= numRoundsInGame {
            currentStartButtonState = startButtonOptions.Restart
            startButton.setTitle("Restart", forState: .Normal)
            roundNumber = 0
        }
        
        startButton.hidden = false
    }

}

extension Array {
    mutating func shuffle() {
        for var i = self.count - 1; i >= 0; i-- {
            let j = Int(arc4random_uniform(UInt32(self.count)))
            swap(&(self[i]), &(self[j]))
        }
    }
    
    func shuffledCopy() -> [Element] {
        var copy : [Element] = Array()
        for element in self {
            let index = Int(arc4random_uniform(UInt32(copy.count+1)))
            copy.insert(element, atIndex: index)
        }
        return copy
    }
}


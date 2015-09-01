//
//  ViewController.swift
//  Multiplication Exercises
//
//  Created by Lauren Bosse on 8/30/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //This is exclusive
    let multiplicationArgsUpperBound: UInt32 = 16
    let numRoundsInGame = 10
    let allowedDistanceFromRightAnswer: UInt32 = 5
    let numPositiveOrNegativeOptions: UInt32 = 2
    
    var roundNumber = 0
    var numQuestionsCorrect = 0
    var numQuestionsAsked = 0
    var randomMultiplicandValue : UInt32 = 0
    var randomMultiplierValue :UInt32 = 0
    var currentAnswer = 0
    var userSelectedAnswer = 0
    
    var answerChoicesArray = [0,0,0,0]
    
    @IBOutlet weak var TESTLABEL: UILabel!
    
    
    
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(sender: AnyObject) {
        if startButton.currentTitle == "Start"{
            startButton.hidden = true
            startButton.setTitle("Next", forState: .Normal)
            
        }
        
        if startButton.currentTitle == "Next"{
            directionLabel.text = "Pick correct answer."
            
            generateMultiplicationArgs()
            currentAnswer = Int(randomMultiplicandValue * randomMultiplierValue)
            populateAnswerChoicesSegmentedControl(currentAnswer)
            answerChoicesSegmentedControl.hidden = false
            
            roundNumber++
            
            if roundNumber >= numRoundsInGame {
                startButton.setTitle("Restart", forState: .Normal)
                roundNumber = 0
            }
            
        }
        
        if startButton.currentTitle == "Restart"{
            startButton.setTitle("Start", forState: .Normal)
        }
    }
    
    @IBAction func answerChoiceIndexChanged(sender: UISegmentedControl) {
        switch answerChoicesSegmentedControl.selectedSegmentIndex {
        case 0:
            userSelectedAnswer = answerChoicesArray[0]
        case 1:
            userSelectedAnswer = answerChoicesArray[1]
        case 2:
            userSelectedAnswer = answerChoicesArray[2]
        case 3:
            userSelectedAnswer = answerChoicesArray[3]
        default:
            break
        }
        
        TESTLABEL.text = "user answer = \(userSelectedAnswer)"
        if userSelectedAnswer == currentAnswer {
            
        } else {
            
        }
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
    
    func populateAnswerChoicesSegmentedControl(answer: Int) {
        answerChoicesArray[0] = answer
        
        var loopCounter = 1
        var tempAnswerChoice = 0
        var tempLoopCounter = 0
        while(loopCounter < answerChoicesSegmentedControl.numberOfSegments){
            tempAnswerChoice = generateAnswerChoice(currentAnswer)
            tempLoopCounter = loopCounter
            for var i = loopCounter; i > 0; i-- {
                if tempAnswerChoice == answerChoicesArray[i]{
                    loopCounter--
                }
            }
            if tempLoopCounter == loopCounter{
                answerChoicesArray[loopCounter] = tempAnswerChoice
            }
            loopCounter++
        }

        answerChoicesArray.shuffle()
        
        //SHUFFLE ANSWERS
        //answerChoicesArray
        /*possible technique:
        
        initialize all to -1.
        inside of while loop:
        
        Pick a random index
        put answer there
        repeat until all have been placed,
        ONLY PLACE IF THE VALUE IN THAT INDEX IS -1
        
        NOTES FROM CLASS
        
        */
        
        var tempAnswerOptionToString = ""
        for var i = 0; i < answerChoicesSegmentedControl.numberOfSegments; i++ {
            answerChoicesSegmentedControl.setTitle("\(answerChoicesArray[i])", forSegmentAtIndex: i)
        }
    }
    
    func generateAnswerChoice(answer: Int) -> Int {
        
        if answer < Int(allowedDistanceFromRightAnswer) {
            return answer + Int(arc4random_uniform(allowedDistanceFromRightAnswer)) + 1
            
        } else {
            //this variable randomly decides whether the random value is added or subtracted
            var plusOrMinusIndicator = Int(arc4random_uniform(numPositiveOrNegativeOptions))
            
            if plusOrMinusIndicator == 0{
                return answer + Int(arc4random_uniform(allowedDistanceFromRightAnswer)) + 1
            }
            else{
                return answer - Int(arc4random_uniform(allowedDistanceFromRightAnswer)) - 1
            }
        }
    }
    
    /* Correct code for naming the progress label
    correctAnswerProgressMessage = "\(numbQuestionsCorrect)/\(numbQuestionsAsked) Questions Correct"
    correctAnswerProgressLabel.text = correctAnswerProgressMessage
    correctAnswerProgressLabel.hidden = false
    */

}

extension Array {
    mutating func shuffle() {
        for var i = self.count - 1; i >= 0; i-- {
            var j = Int(arc4random_uniform(UInt32(i)))
            swap(&(self[i]), &(self[j]))
        }
    }
    
    func shuffledCopy() -> [Element] {
        var copy : [T] = Array()
        for element in self {
            let index = Int(arc4random_uniform(UInt32(copy.count+1)))
            copy.insert(element, atIndex: index)
        }
        return copy
    }
}


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
    
    var answerChoicesArray = [0,0,0,0]
    
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
        
        /* figure out how to populate the other three
        var answerChoicesArrayIsPopulated = 0
        var counter = 0
        while(answerChoicesArrayIsPopulated != 1){
            
        }
        */
        //SHUFFLE ANSWERS
        //answerChoicesArray
        
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


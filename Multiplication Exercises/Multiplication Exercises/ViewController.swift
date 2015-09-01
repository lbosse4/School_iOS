//
//  ViewController.swift
//  Multiplication Exercises
//
//  Created by Lauren Bosse on 8/30/15.
//  Copyright (c) 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let numbPossibleAnswers = 4
    //This is exclusive
    let multiplicationArgsUpperBound: UInt32 = 16
    let numbRoundsInGame = 10
    let allowedDistanceFromRightAnswer: UInt32 = 5
    
    var roundNumber = 0
    var numbQuestionsCorrect = 0
    var numbQuestionsAsked = 0
    var randomMultiplicandValue : UInt32 = 0
    var randomMultiplierValue :UInt32 = 0
    var currentAnswer = 0
    
    var answerChoicesArray = [0,0,0,0]
    
    var multiplicandValueToText = ""
    var multiplierValueToText = ""
    var correctAnswerProgressMessage = ""
    
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
            
            if roundNumber >= numbRoundsInGame {
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
        
        multiplicandValueToText = "\(randomMultiplicandValue)"
        multiplierValueToText = "\(randomMultiplierValue)"
        
        multiplicandLabel.text = multiplicandValueToText
        multiplierLabel.text = multiplierValueToText
        
        multiplicandLabel.hidden = false
        multiplierLabel.hidden = false
        multiplicationSymbolLabel.hidden = false
        horizontalLineLabel.hidden = false
    }
    
    func populateAnswerChoicesSegmentedControl(answer:Int) {
        answerChoicesArray[0] = answer
        answerChoicesArray[1] = answer + Int(arc4random_uniform(allowedDistanceFromRightAnswer)) + 1
        answerChoicesArray[2] = answer + Int(arc4random_uniform(allowedDistanceFromRightAnswer)) + 1
        answerChoicesArray[3] = answer + Int(arc4random_uniform(allowedDistanceFromRightAnswer)) + 1
        
        //SHUFFLE ANSWERS
        //answerChoicesArray
        
        var tempAnswerOptionToString = ""
        for var i = 0; i < answerChoicesSegmentedControl.numberOfSegments; i++ {
            answerChoicesSegmentedControl.setTitle("\(answerChoicesArray[i])", forSegmentAtIndex: i)
        }
    }
    
    
    /* Correct code for naming the progress label
    correctAnswerProgressMessage = "\(numbQuestionsCorrect)/\(numbQuestionsAsked) Questions Correct"
    correctAnswerProgressLabel.text = correctAnswerProgressMessage
    correctAnswerProgressLabel.hidden = false
    */

}


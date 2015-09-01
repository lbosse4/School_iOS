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
    let multiplicationArgsUpperBound : UInt32 = 16
    var numbQuestionsCorrect = 0
    var numbQuestionsAsked = 0
    var randomMultiplicandValue : UInt32 = 0
    var randomMultiplierValue :UInt32 = 0
    var multiplicandValueToText = ""
    var multiplierValueToText = ""
    var correctAnswerProgressMessage = ""
    
    @IBOutlet weak var multiplicandLabel: UILabel!
    @IBOutlet weak var multiplierLabel: UILabel!
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
            directionLabel.text = "Pick correct answer."
            startButton.setTitle("Next", forState: .Normal)
            generateMultiplicationArgs()
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
    
    /* Correct code for naming the progress label
    correctAnswerProgressMessage = "\(numbQuestionsCorrect)/\(numbQuestionsAsked) Questions Correct"
    correctAnswerProgressLabel.text = correctAnswerProgressMessage
    correctAnswerProgressLabel.hidden = false
    */

}


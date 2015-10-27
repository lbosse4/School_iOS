//
//  ListedDirectionsViewController.swift
//  Campus Walk
//
//  Created by Lauren Bosse on 10/26/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit
import MapKit

class ListedDirectionsViewController : UIViewController, UIScrollViewDelegate {
    var directionResponse : MKDirectionsResponse?
    let labelHeight : CGFloat = 30.0
    let labelFont : String = "Palatino"
    let labelFontSize : CGFloat = 14.0
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        for route in directionResponse!.routes{
            var loopCounter : Int = 0
            for step in route.steps {
                let labelFrame = CGRect(x: 0.0, y: CGFloat(loopCounter) * labelHeight, width: view.frame.width, height: labelHeight)
                let label = UILabel(frame: labelFrame)
                label.font = UIFont(name: labelFont, size: labelFontSize)
                label.textColor = UIColor.whiteColor()
                label.text = step.instructions
                label.textAlignment = .Center
                loopCounter += 1
                scrollView.addSubview(label)
            }
        }
        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(directionResponse!.routes[0].steps.count) * labelHeight)
    }
    @IBAction func thanksButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

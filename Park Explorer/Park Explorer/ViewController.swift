//
//  ViewController.swift
//  Park Explorer
//
//  Created by Lauren Bosse on 9/27/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let model = Model()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        model.extractParkInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


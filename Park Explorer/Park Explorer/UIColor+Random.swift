//
//  UIColor+Random.swift
//  Scroller
//
//  Created by John Hannan on 9/22/15.
//  Copyright (c) 2015 John Hannan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        let color = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
        return color
    }
}
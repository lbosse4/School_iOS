//
//  Player.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/17/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import Foundation
import CoreData


class Player: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func firstLetter() -> String? {
        let name = self.name!
        return name.substringToIndex(name.startIndex.advancedBy(1))
        
    }
}

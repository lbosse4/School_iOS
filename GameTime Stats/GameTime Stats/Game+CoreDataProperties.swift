//
//  Game+CoreDataProperties.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/17/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Game {

    @NSManaged var date: NSDate?
    @NSManaged var guestScore: NSNumber?
    @NSManaged var homeScore: NSNumber?
    @NSManaged var opponentName: String?
    @NSManaged var team: Team?
    @NSManaged var periods: NSSet?

}

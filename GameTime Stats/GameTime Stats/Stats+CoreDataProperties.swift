//
//  Stats+CoreDataProperties.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/15/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Stats {

    @NSManaged var assists: NSNumber?
    @NSManaged var causedTurnovers: NSNumber?
    @NSManaged var clears: NSNumber?
    @NSManaged var drawControls: NSNumber?
    @NSManaged var freePositionAttempts: NSNumber?
    @NSManaged var freePositionGoals: NSNumber?
    @NSManaged var freePositionPercentage: NSNumber?
    @NSManaged var goals: NSNumber?
    @NSManaged var groundBalls: NSNumber?
    @NSManaged var opponentGoalsScoredAgainst: NSNumber?
    @NSManaged var savePercentage: NSNumber?
    @NSManaged var saves: NSNumber?
    @NSManaged var shotPercentage: NSNumber?
    @NSManaged var shotsOnGoal: NSNumber?
    @NSManaged var turnovers: NSNumber?
    @NSManaged var timePlayed: NSData?
    @NSManaged var game: Game?
    @NSManaged var player: Player?

}

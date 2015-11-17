//
//  Player+CoreDataProperties.swift
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

extension Player {

    @NSManaged var jerseyNumber: NSNumber?
    @NSManaged var name: String?
    @NSManaged var position: String?
    @NSManaged var stats: NSSet?
    @NSManaged var team: Team?

}

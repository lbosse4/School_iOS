//
//  Team+CoreDataProperties.swift
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

extension Team {

    @NSManaged var logo: NSObject?
    @NSManaged var majorColor: NSObject?
    @NSManaged var minorColor: NSObject?
    @NSManaged var name: String?
    @NSManaged var players: NSSet?
    @NSManaged var games: NSSet?

}

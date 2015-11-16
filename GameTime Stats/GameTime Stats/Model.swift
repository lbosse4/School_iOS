//
//  Model.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import CoreData
import Foundation

struct PositionsKey {
    static let Defender = "Defender"
    static let Attacker = "Attacker"
    static let MidFielder = "Midfielder"
    static let Goalie = "Goalie"
}

struct ObejctsKey {
    static let Player = "Player"
    static let Team = "Team"
    static let Stats = "Stats"
    static let Game = "Game"
}

class Model : DataManagerDelegate {
    static let sharedInstance = Model()
    
    let dataManager = DataManager.sharedInstance
    var teams : [Team]!
    var testPlayers : [Player]!

    private init() {
        dataManager.delegate = self
        teams = dataManager.fetchManagedObjectsForEntity(ObejctsKey.Team, sortKeys: ["name"], predicate: nil) as! [Team]
        testPlayers = dataManager.fetchManagedObjectsForEntity(ObejctsKey.Player, sortKeys: ["jerseyNumber"], predicate: nil) as! [Player]
    }
    
    func xcDataModelName() -> String {
        return "LacrossePlayers"
    }
    
    func createDatabase() {
        let t = NSEntityDescription.insertNewObjectForEntityForName(ObejctsKey.Team, inManagedObjectContext: dataManager.managedObjectContext!) as! Team
        let g = NSEntityDescription.insertNewObjectForEntityForName(ObejctsKey.Game, inManagedObjectContext: dataManager.managedObjectContext!) as! Game
        
        t.name = "Melizza Rox"
        g.team = t
        g.opponentName = "Losers"
        g.date = NSDate()
        
        for i in 0..<12 {
            let p = NSEntityDescription.insertNewObjectForEntityForName(ObejctsKey.Player, inManagedObjectContext: dataManager.managedObjectContext!) as! Player
            p.name = "Player\(i)"
            p.jerseyNumber = i
            p.team = t
            p.position = PositionsKey.Defender
            
            let s = NSEntityDescription.insertNewObjectForEntityForName(ObejctsKey.Stats, inManagedObjectContext: dataManager.managedObjectContext!) as! Stats
            s.assists = 0
            s.causedTurnovers = 0
            s.clears = 0
            s.drawControls = 0
            s.freePositionAttempts = 0
            s.freePositionGoals = 0
            s.freePositionPercentage = 0.0
            s.goals = 0
            s.groundBalls = 0
            s.opponentGoalsScoredAgainst = 0
            s.savePercentage = 0.0
            s.saves = 0
            s.shotPercentage = 0.0
            s.shotsOnGoal = 0
            s.turnovers = 0
            s.game = g
            s.player = p
        }
        dataManager.saveContext()
    }
    
    func tstPlayers() -> [Player] {
        return testPlayers
    }
    
}




















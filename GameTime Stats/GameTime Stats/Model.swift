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

struct ObjectsKey {
    static let Player = "Player"
    static let Team = "Team"
    static let Stats = "Stats"
    static let Game = "Game"
}

class Model : DataManagerDelegate {
    static let sharedInstance = Model()
    
    let dataManager = DataManager.sharedInstance
    var teams : [Team]!
    var players : [Player]!

    private init() {
        dataManager.delegate = self
        teams = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Team, sortKeys: ["name"], predicate: nil) as! [Team]
        players = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Player, sortKeys: ["jerseyNumber"], predicate: nil) as! [Player]
    }
    
    func xcDataModelName() -> String {
        return "LacrossePlayers"
    }
    
    func createDatabase() {
        /*
        let t = NSEntityDescription.insertNewObjectForEntityForName(ObjectsKey.Team, inManagedObjectContext: dataManager.managedObjectContext!) as! Team
        let g = NSEntityDescription.insertNewObjectForEntityForName(ObjectsKey.Game, inManagedObjectContext: dataManager.managedObjectContext!) as! Game
        
        t.name = "Melizza Rox"
        g.team = t
        g.opponentName = "Losers"
        g.date = NSDate()
        
        for i in 0..<12 {
            let p = NSEntityDescription.insertNewObjectForEntityForName(ObjectsKey.Player, inManagedObjectContext: dataManager.managedObjectContext!) as! Player
            p.name = "Player\(i)"
            p.jerseyNumber = i
            p.team = t
            p.position = PositionsKey.Defender
            
            let s = NSEntityDescription.insertNewObjectForEntityForName(ObjectsKey.Stats, inManagedObjectContext: dataManager.managedObjectContext!) as! Stats
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
            //s.game = g
            s.player = p
        }
        dataManager.saveContext()*/
        
        dataManager.saveContext()
    }
    
    func tstPlayers() -> [Player] {
        return players
    }
    
    func playerCount() -> Int {
        return players.count
    }
    
    func playerAtIndex(index:Int) -> Player {
        let player = players[index]
        return player
        //return player[FootballerKey.Name]! as! String
        
    }
    
    func addPlayerWithName(name: String, team: Team, number: Int, position: String) {
        let playerObj = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: dataManager.managedObjectContext!) as! Player
        playerObj.name = name
        playerObj.team = team
        playerObj.jerseyNumber = number
        playerObj.position = position
        dataManager.saveContext()
        
    }

    func addTeamWithName(name: String) -> Team {
        let teamObj = NSEntityDescription.insertNewObjectForEntityForName(ObjectsKey.Team, inManagedObjectContext: dataManager.managedObjectContext!) as! Team
        teamObj.name = name
        dataManager.saveContext()
        return teamObj
        
    }
    
    func positionAtIndex(index: Int) -> String {
        switch index {
        case 0:
            return PositionsKey.Defender
        case 1:
            return PositionsKey.Attacker
        case 2:
            return PositionsKey.MidFielder
        case 3:
            return PositionsKey.Goalie
        default:
            return ""
        }
    }
    
}




















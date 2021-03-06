//
//  Model.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import CoreData
import UIKit
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
    static let Period = "Period"
}

struct PeriodType {
    static let FirstHalf = "First Half"
    static let SecondHalf = "Second Half"
    static let Overtime = "Overtime"
}

class Model : DataManagerDelegate {
    static let sharedInstance = Model()
    let numAddPlayerWalkthroughImages = 3
    let numGameWalkthroughImages = 6
    
    let dataManager = DataManager.sharedInstance
    let numPeriodTypes = 3
    private var teams : [Team]!
    private var players : [Player]!
    private var addPlayerWalkthroughImages = [String]()
    private var gameWalkthroughImages = [String]()

    private init() {
        dataManager.delegate = self
        teams = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Team, sortKeys: ["name"], predicate: nil) as! [Team]
        players = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Player, sortKeys: ["jerseyNumber"], predicate: nil) as! [Player]
        for i in 0 ..< numAddPlayerWalkthroughImages {
            let imageString = "AddPlayersWalkthrough\(i + 1).png"
            addPlayerWalkthroughImages.append(imageString)
        }
        
        for i in 0 ..< numGameWalkthroughImages {
            let imageString = "GameWalkthrough\(i + 1).png"
            gameWalkthroughImages.append(imageString)
        }
    }
    
    func xcDataModelName() -> String {
        return "LacrossePlayers"
    }
    
    func createDatabase() {
        dataManager.saveContext()
    }
    
    //Save the datamanager context
    func saveDMContext(){
        dataManager.saveContext()
    }
    
    //all players in database
    func tstPlayers() -> [Player] {
        return players
    }
    
    //number of players in the database
    func playerCount() -> Int {
        return players.count
    }
    
    func testTeams() -> [Team]{
        return teams
    }
    
    //number of teams in database
    func teamCount() -> Int {
        return teams.count
    }
    
    func addPlayerWalkthroughImageStrings() -> [String] {
        return addPlayerWalkthroughImages
    }
    
    func gameWalkthroughImageStrings() -> [String] {
        return gameWalkthroughImages
    }
    
    func numAPWalkthroughImages() -> Int {
        return numAddPlayerWalkthroughImages
    }
    
    func numGWalkthroughImages() -> Int {
        return numGameWalkthroughImages
    }
    
    func numberOfPeriodTypes() -> Int {
        return numPeriodTypes
    }
    
    //makes sure teams nd players are synced with datamanager
    func updateTeamsAndPlayers(){
        teams = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Team, sortKeys: ["name"], predicate: nil) as! [Team]
        players = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Player, sortKeys: ["jerseyNumber"], predicate: nil) as! [Player]
    }
    
    func teamAtIndex(index:Int) -> Team {
        return teams[index]
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
        //players = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Player, sortKeys: ["jerseyNumber"], predicate: nil) as! [Player]
        updateTeamsAndPlayers()
    }
    
    func addGameObject(team : Team, date : NSDate, opponentTeamName : String) -> Game {
        let gameObj = NSEntityDescription.insertNewObjectForEntityForName(ObjectsKey.Game, inManagedObjectContext: dataManager.managedObjectContext!) as! Game
        gameObj.team = team
        gameObj.date = date
        gameObj.opponentName = opponentTeamName
        //dataManager.saveContext()
        return gameObj
        
    }
    
    func addStatsObject(player: Player, game: Game, currentPeriod: String) -> Stats{
        let periodObj = NSEntityDescription.insertNewObjectForEntityForName(ObjectsKey.Period, inManagedObjectContext: dataManager.managedObjectContext!) as! Period
        periodObj.game = game
        periodObj.type = currentPeriod
        
        let statsObj = NSEntityDescription.insertNewObjectForEntityForName(ObjectsKey.Stats, inManagedObjectContext: dataManager.managedObjectContext!) as! Stats
        statsObj.player = player
        statsObj.period = periodObj
        dataManager.saveContext()
        return statsObj
    }

    func addTeamWithName(name: String, majorColor: UIColor, minorColor: UIColor) -> Team {
        let teamObj = NSEntityDescription.insertNewObjectForEntityForName(ObjectsKey.Team, inManagedObjectContext: dataManager.managedObjectContext!) as! Team
        teamObj.name = name
        let majorData = NSKeyedArchiver.archivedDataWithRootObject(majorColor)
        let minorData = NSKeyedArchiver.archivedDataWithRootObject(minorColor)
        teamObj.majorColor = majorData//majorColor
        teamObj.minorColor = minorData//minorColor
        dataManager.saveContext()
        updateTeamsAndPlayers()
        return teamObj
    }
    
    func updateMajorColorForTeam(team: Team, majorColor: UIColor) {
        let majorData = NSKeyedArchiver.archivedDataWithRootObject(majorColor)
        team.majorColor = majorData
    }
    
    func updateMinorColorForTeam(team: Team, minorColor: UIColor) {
        let minorData = NSKeyedArchiver.archivedDataWithRootObject(minorColor)
        team.minorColor = minorData
    }
    
    func majorColorForTeam(team: Team) -> UIColor {
        
        let data = team.majorColor as! NSData
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! UIColor
    }
    
    func minorColorForTeam(team: Team) -> UIColor {
        
        let data = team.minorColor as! NSData
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! UIColor
    }
    
    //essentially an enum for positions
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
    
    func teamWithName(teamName : String) -> Team {
        let predicate = NSPredicate(format: "name == %@", teamName)
        let teams = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Team, sortKeys: ["name"], predicate: predicate) as! [Team]
        return teams[0]
    }
    
    func playersForTeam(team: Team) -> [Player]{
        let teamName = team.name!
        let predicate = NSPredicate(format: "team.name == %@", teamName)
        let players = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Player, sortKeys: ["jerseyNumber"], predicate: predicate) as! [Player]
        
        return players
    }
    
    func gamesForTeam(team: Team) -> [Game]{
        let teamName = team.name!
        let predicate = NSPredicate(format: "team.name == %@", teamName)
        let games = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Game, sortKeys: ["date"], predicate: predicate) as! [Game]
        
        return games
    }
    
    func statsForPlayer(player: Player, game: Game, periodType: String) -> Stats{
        var predicatesArray = [NSPredicate]()
        
        let jerseyNumber = player.jerseyNumber!
        let pred1 = NSPredicate(format: "player.jerseyNumber == %@", jerseyNumber)
        predicatesArray.append(pred1)
        
        let playerName = player.name!
        let pred2 = NSPredicate(format: "player.name == %@", playerName)
        predicatesArray.append(pred2)
        
        //let periodType = period.type!
        let pred3 = NSPredicate(format: "period.type == %@", periodType)
        predicatesArray.append(pred3)
        
        let gameDate = game.date!
        let pred4 = NSPredicate(format: "period.game.date == %@", gameDate)
        predicatesArray.append(pred4)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicatesArray)
        let statsObj = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Stats, sortKeys: ["period.type"], predicate: compound) as! [Stats]
        
        return statsObj[0]
    }
    
    func allStatsForPlayer(player: Player, game: Game) -> [Stats]{
        var predicatesArray = [NSPredicate]()
        
        let jerseyNumber = player.jerseyNumber!
        let pred1 = NSPredicate(format: "player.jerseyNumber == %@", jerseyNumber)
        predicatesArray.append(pred1)
        
        let playerName = player.name!
        let pred2 = NSPredicate(format: "player.name == %@", playerName)
        predicatesArray.append(pred2)

        let gameDate = game.date!
        let pred3 = NSPredicate(format: "period.game.date == %@", gameDate)
        predicatesArray.append(pred3)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicatesArray)
        let statsObj = dataManager.fetchManagedObjectsForEntity(ObjectsKey.Stats, sortKeys: ["period.type"], predicate: compound) as! [Stats]
        return statsObj
    }
    
    func deleteGame(game : Game){
        let context = self.dataManager.managedObjectContext!
        context.deleteObject(game)
        updateTeamsAndPlayers()
        dataManager.saveContext()
    }
    
    func deleteTeam(team : Team){
        let context = self.dataManager.managedObjectContext!
        context.deleteObject(team)
        updateTeamsAndPlayers()
        dataManager.saveContext()
    }
    
}




















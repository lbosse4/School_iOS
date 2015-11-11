//
//  Model.swift
//  GameTime Stats
//
//  Created by Lauren Bosse on 11/11/15.
//  Copyright © 2015 Lauren Bosse. All rights reserved.
//

import Foundation

struct PositionsKey {
    static let Defender = "Defender"
    static let Attacker = "Attacker"
    static let MidFielder = "Midfielder"
    static let Goalie = "Goalie"
}

class Model : DataManagerDelegate {
    static let sharedInstance = Model()
    
    let dataManager = DataManager.sharedInstance
    
    private init() {
        dataManager.delegate = self
    }
    
    func xcDataModelName() -> String {
        return "LacrossePlayers"
    }
    
    func createDatabase() {
        
    }
}
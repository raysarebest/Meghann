//
//  MHGame.swift
//  
//
//  Created by Michael Hulet on 5/22/15.
//
//

import Foundation
import CoreData

enum GameMergeError: ErrorType{
    case DifferentGames
}

class MHGame: NSManagedObject{
    //Core Data Stored Properties
    @NSManaged var date: NSDate
    @NSManaged var score: NSNumber
    @NSManaged var bucketsHit: NSNumber
    @NSManaged var shotsMade: NSNumber
    @NSManaged var bucketsLastUpdated: NSDate
    @NSManaged var shotsLastUpdated: NSDate
    //Core Data Helper Functions
    func setHitBuckets(value: Int) -> Void{
        bucketsHit = NSNumber(integer: value)
        bucketsLastUpdated = NSDate()
        calculateScore()
    }
    func setMadeShots(value: Int) -> Void{
        shotsMade = NSNumber(integer: value)
        shotsLastUpdated = NSDate()
        calculateScore()
    }
    //Private Helper Functions
    private func calculateScore() -> Void{
        score = NSNumber(integer: (shotsMade.integerValue * 2) + bucketsHit.integerValue)
        MHCoreDataStack.defaultStack.saveContext()
    }
    func mergeWithGame(game: MHGame) throws -> Void{
        guard game.date == date else{
            throw GameMergeError.DifferentGames
        }
        if bucketsLastUpdated < game.bucketsLastUpdated{
            setHitBuckets(game.bucketsHit.integerValue)
        }
        if shotsLastUpdated < game.shotsLastUpdated{
            setMadeShots(game.shotsMade.integerValue)
        }
        calculateScore()
    }
}

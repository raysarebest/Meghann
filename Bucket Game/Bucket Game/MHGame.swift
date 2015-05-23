//
//  MHGame.swift
//  
//
//  Created by Michael Hulet on 5/22/15.
//
//

import Foundation
import CoreData

class MHGame: NSManagedObject {
    //Core Data Stored Properties
    @NSManaged var date: NSDate
    @NSManaged var score: NSNumber
    @NSManaged var bucketsHit: NSNumber
    @NSManaged var shotsMade: NSNumber
    //Core Data Helper Functions
    func setHitBuckets(double: Double) -> Void{
        bucketsHit = NSNumber(double: double)
        calculateScore()
    }
    func setMadeShots(double: Double) -> Void{
        shotsMade = NSNumber(double: double)
        calculateScore()
    }
    //Private Helper Functions
    private func calculateScore() -> Void{
        score = NSNumber(double: (shotsMade.doubleValue * 2) + bucketsHit.doubleValue)
        MHCoreDataStack.defaultStack.saveContext()
    }
}

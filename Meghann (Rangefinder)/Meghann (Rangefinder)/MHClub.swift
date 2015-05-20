//
//  MHClub.swift
//  
//
//  Created by Michael Hulet on 4/27/15.
//
//

import Foundation
import CoreData
class MHClub: NSManagedObject{
    //MARK: - Core Data Properties
    @NSManaged var name: String
    @NSManaged var shots: NSOrderedSet
    @NSManaged var averageDistance: Double
    //MARK: - Core Data Helper Functions
    func addShot(shot: MHShot) -> Void{
        shot.club = self
        let mutableShots = shots.mutableCopy() as! NSMutableOrderedSet
        mutableShots.addObject(shot)
        shots = mutableShots.copy() as! NSOrderedSet
        updateAverageDistance()
    }
    func removeShot(shot: MHShot) -> Void{
        if shots.containsObject(shot){
            let mutableShots = shots.mutableCopy() as! NSMutableOrderedSet
            mutableShots.removeObject(shot)
            shots = mutableShots
            MHCoreDataStack.defaultStack.managedObjectContext!.deleteObject(shot)
            updateAverageDistance()
        }
    }
    func removeShotAtIndex(index: Int) -> Void{
        removeShot(shots[index] as! MHShot)
    }
    //Private Helper Functions
    private func updateAverageDistance() -> Void{
        var total: Double = 0
        for shot in shots{
            total += (shot as! MHShot).distance.doubleValue
        }
        averageDistance = total / Double(shots.count)
    }
}
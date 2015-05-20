//
//  MHShot.swift
//  
//
//  Created by Michael Hulet on 4/27/15.
//
//

import Foundation
import CoreData
class MHShot: NSManagedObject{
    //MARK: - Core Data Properties
    @NSManaged var distance: NSNumber
    @NSManaged var club: MHClub
    //MARK: - Convenience Initializers
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, club: MHClub){
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.club = club
    }
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, distance: NSNumber){
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.distance = distance
    }
    convenience init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, yards: Double){
        self.init(entity: entity, insertIntoManagedObjectContext: context, distance: NSNumber(double: yards))
    }
}
//
//  MHDataSynchronizer.swift
//  Bucket Game
//
//  Created by Michael Hulet on 4/12/16.
//  Copyright © 2016 Michael Hulet. All rights reserved.
//

import CoreData

enum MHGameSerializationKeys: String{
    case GameClassName = "MHGame"
    case NewObject = "MHGameShouldCreateNewObjectKey"
    case Date = "MHGameSerializationDateKey"
}

class MHDataSynchronizer: MHPeripheralCommunicationDelegate{
    //MARK: - MHPeripheralCommunicationDelegate Methods
    func applicationDidRecieveData(data: [String: AnyObject], responseHandler: (([String : AnyObject]) -> Void)?) -> Void{
        if data[MHGameSerializationKeys.NewObject.rawValue] as! Bool{
            let new = NSEntityDescription.insertNewObjectForEntityForName(MHGameSerializationKeys.GameClassName.rawValue, inManagedObjectContext: MHCoreDataStack.defaultStack.managedObjectContext!)
            constructGame(new as! MHGame, withData: data)
        }
    }
    //MARK: - Private Helpers
    private func constructGame(game: MHGame, withData data: [String: AnyObject]) -> Void{

    }
}
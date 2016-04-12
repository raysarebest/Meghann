//
//  InterfaceController.swift
//  bucket-watch Extension
//
//  Created by Michael Hulet on 3/29/16.
//  Copyright © 2016 Michael Hulet. All rights reserved.
//

import WatchKit
import CoreData

class MHListController: WKInterfaceController{
    @IBOutlet var gameTable: WKInterfaceTable!
    override func awakeWithContext(context: AnyObject?) -> Void{
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    override func willActivate() -> Void{
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    override func didDeactivate() -> Void{
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
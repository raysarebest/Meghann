//
//  MasterViewController.swift
//  Bucket Game
//
//  Created by Michael Hulet on 5/22/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

import UIKit
import CoreData
class MHMasterViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    //MARK: - Global Variables
    lazy var results: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "MHGame")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: MHCoreDataStack.defaultStack.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() -> Void{
        super.viewDidLoad()
        do{
            try results.performFetch()
        }
        catch let error as NSError{
            print(error)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) -> Void{
        if segue.identifier == "showDetail"{
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
            (segue.destinationViewController as! MHDetailViewController).game = results.objectAtIndexPath(selectedIndexPath) as? MHGame
        }
        super.prepareForSegue(segue, sender: sender)
    }
    //MARK: - UITableViewDataSource Functions
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return results.sections!.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (results.sections![section] as NSFetchedResultsSectionInfo).numberOfObjects
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let formatter = NSDateFormatter()
        let game = results.objectAtIndexPath(indexPath) as! MHGame
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = formatter.stringFromDate(game.date)
        cell.detailTextLabel!.text = "\(game.score)"
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) -> Void{
        if editingStyle == .Delete{
            MHCoreDataStack.defaultStack.managedObjectContext!.deleteObject(results.objectAtIndexPath(indexPath) as! NSManagedObject)
            MHCoreDataStack.defaultStack.saveContext()
        }
    }
    //MARK: - NSFetchedResultsControllerDelegate Functions
    func controllerDidChangeContent(controller: NSFetchedResultsController) -> Void{
        tableView.reloadData()
    }
    //MARK: - IBActions
    @IBAction func newGame() -> Void{
        let newGame = NSEntityDescription.insertNewObjectForEntityForName("MHGame", inManagedObjectContext: MHCoreDataStack.defaultStack.managedObjectContext!) as! MHGame
        newGame.date = NSDate()
        MHCoreDataStack.defaultStack.saveContext()
        tableView.selectRowAtIndexPath(results.indexPathForObject(newGame), animated: true, scrollPosition: .Top)
        performSegueWithIdentifier("showDetail", sender: self)
    }
}
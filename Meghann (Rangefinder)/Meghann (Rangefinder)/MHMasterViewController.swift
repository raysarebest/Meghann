//
//  MasterViewController.swift
//  Meghann (Rangefinder)
//
//  Created by Michael Hulet on 4/27/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

import UIKit
import CoreData
class MHMasterViewController: UITableViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    //MARK: - Global Variables
    lazy var results: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "MHClub")
        request.sortDescriptors = [NSSortDescriptor(key: "averageDistance", ascending: false), NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: MHCoreDataStack.defaultStack.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() -> Void{
        super.viewDidLoad()
        var error: NSError? = nil
        results.performFetch(&error)
        if let realError = error{
            println(realError)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) -> Void{
        if segue.identifier == "showDetail"{
            let selectedIndexPath = tableView.indexPathForSelectedRow()!
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
            (segue.destinationViewController as! MHDetailViewController).club = results.objectAtIndexPath(selectedIndexPath) as? MHClub
        }
        super.prepareForSegue(segue, sender: sender)
    }
    //MARK: - IBActions
    @IBAction func newClub() -> Void{
        let alert = UIAlertController(title: "New Club", message: "What's the name of your new club?", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "New Club"
            textField.returnKeyType = .Done
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            let newClub = NSEntityDescription.insertNewObjectForEntityForName("MHClub", inManagedObjectContext: MHCoreDataStack.defaultStack.managedObjectContext!) as! MHClub
            newClub.name = (alert.textFields!.first as! UITextField).text
            MHCoreDataStack.defaultStack.saveContext()
            self.tableView.reloadData()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    //MARK: - UITableViewDataSource Functions
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return results.sections!.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (results.sections![section] as! NSFetchedResultsSectionInfo).numberOfObjects
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let club = results.objectAtIndexPath(indexPath) as! MHClub
        cell.textLabel!.text = club.name
        cell.detailTextLabel!.text = "\(club.averageDistance) Yards"
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
}
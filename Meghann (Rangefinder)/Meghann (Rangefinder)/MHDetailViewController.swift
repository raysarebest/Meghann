//
//  DetailViewController.swift
//  Meghann (Rangefinder)
//
//  Created by Michael Hulet on 4/27/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

import UIKit
import CoreData
import Foundation
class MHDetailViewController: UIViewController, UITableViewDataSource{
    //IBOutlets
    @IBOutlet weak var clubLabel: UILabel!
    @IBOutlet weak var averageDistanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Class Variables
    var club: MHClub?
    //IBActions
    @IBAction func newShot() -> Void{
        let alert = UIAlertController(title: "New Shot", message: "How far did it go in yards?", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "Distance"
            textField.keyboardType = .NumberPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            let newShot = NSEntityDescription.insertNewObjectForEntityForName("MHShot", inManagedObjectContext: MHCoreDataStack.defaultStack.managedObjectContext!) as! MHShot
            newShot.distance = NSString(string: (alert.textFields!.first as! UITextField).text).doubleValue
            self.club!.addShot(newShot)
            MHCoreDataStack.defaultStack.saveContext()
            self.updateInterfaceData()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() -> Void{
        super.viewDidLoad()
        tableView.dataSource = self
        clubLabel.text = club!.name
        updateInterfaceData()
        navigationItem.title = club!.name
    }
    //MARK: - Helper Functions
    private func updateInterfaceData() -> Void{
        averageDistanceLabel.text = "\(Int(round(club!.averageDistance)))"
        tableView.reloadData()
    }
    //MARK: - UITableViewDataSource Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let realClub = club{
            return realClub.shots.count
        }
        else{
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.detailTextLabel!.text = "\((club!.shots[indexPath.row] as! MHShot).distance) Yards"
        cell.textLabel!.text = "Shot #\(indexPath.row + 1)"
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) -> Void{
        if editingStyle == .Delete{
            club!.removeShotAtIndex(indexPath.row)
            MHCoreDataStack.defaultStack.saveContext()
            updateInterfaceData()
        }
    }
}
//
//  DetailViewController.swift
//  Bucket Game
//
//  Created by Michael Hulet on 5/22/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

import UIKit
class MHDetailViewController: UIViewController{
    //MARK: - IBOutlets
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var bucketsHitLabel: UILabel!
    @IBOutlet weak var shotsMadeLabel: UILabel!
    @IBOutlet weak var bucketsHitStepper: UIStepper!
    @IBOutlet weak var shotsMadeStepper: UIStepper!
    //MARK: - Global Constants
    var game: MHGame?
    //MARK: - IBActions
    @IBAction func updateScoreWithStepper(sender: UIStepper) -> Void{
        var label: UILabel? = nil
        if sender == bucketsHitStepper{
            label = bucketsHitLabel
            game!.setHitBuckets(Int(sender.value))
        }
        else if sender == shotsMadeStepper{
            label = shotsMadeLabel
            game!.setMadeShots(Int(sender.value))
        }
        label!.text = "\(Int(sender.value))"
        totalLabel.text = "\(game!.score.integerValue)"
    }
    //MARK: View Controller Lifecycle
    override func viewDidLoad() -> Void{
        super.viewDidLoad()
        bucketsHitStepper.value = game!.bucketsHit.doubleValue
        updateScoreWithStepper(bucketsHitStepper)
        shotsMadeStepper.value = game!.shotsMade.doubleValue
        updateScoreWithStepper(shotsMadeStepper)
    }
}
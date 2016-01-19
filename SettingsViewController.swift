//
//  SettingsViewController.swift
//  tips
//
//  Created by Zubair Khan on 1/8/16.
//  Copyright © 2016 zapps. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var firstPercentage: UITextField!
    @IBOutlet weak var secondPercentage: UITextField!
    @IBOutlet weak var thirdPercentage: UITextField!
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var themeControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = NSUserDefaults.standardUserDefaults()
        let percentages = defaults.arrayForKey("tipPercentages")!
        firstPercentage.text = String(percentages[0] as! NSNumber)
        secondPercentage.text = String(percentages[1] as! NSNumber)
        thirdPercentage.text = String(percentages[2] as! NSNumber)
        themeControl.selectedSegmentIndex = defaults.boolForKey("lightTheme") ? 0 : 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func discard(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func save(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()

        defaults.setObject(
            [
                Int(firstPercentage.text!)!,
                Int(secondPercentage.text!)!,
                Int(thirdPercentage.text!)!,
            ],
            forKey: "tipPercentages"
        )
        defaults.setBool(themeControl.selectedSegmentIndex == 0, forKey: "lightTheme")
        dismissViewControllerAnimated(true, completion: nil)
    }
}

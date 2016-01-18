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
        firstPercentage.text = String(defaults.integerForKey("firstPercentage"))
        secondPercentage.text = String(defaults.integerForKey("secondPercentage"))
        thirdPercentage.text = String(defaults.integerForKey("thirdPercentage"))
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
        defaults.setInteger(Int(firstPercentage.text!)!, forKey: "firstPercentage")
        defaults.setInteger(Int(secondPercentage.text!)!, forKey: "secondPercentage")
        defaults.setInteger(Int(thirdPercentage.text!)!, forKey: "thirdPercentage")
        defaults.setBool(themeControl.selectedSegmentIndex == 0, forKey: "lightTheme")
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

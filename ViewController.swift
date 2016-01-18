//
//  ViewController.swift
//  tips
//
//  Created by Zubair Khan on 12/29/15.
//  Copyright © 2015 zapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var lowerSubView: UIView!
    @IBOutlet var viewController: UIView!

    var hadZeroValue = true

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()

        let defaults = NSUserDefaults.standardUserDefaults()
        let dateLastEntered = defaults.objectForKey("dateLastEntered") as! NSDate!
        let lastBillAmount = defaults.doubleForKey("lastBillAmount")
        if dateLastEntered == nil {
            return
        }

        self.viewController.backgroundColor = UIColor.blueColor()

        let now = NSDate()
        let secSinceLastEntered = now.timeIntervalSinceDate(dateLastEntered)
        if secSinceLastEntered < 20 {
            if lastBillAmount == 0 {
                billField.text = ""
            } else if lastBillAmount % 1 == 0 {
                billField.text = String(format:"%d", Int(lastBillAmount))
            } else {
                billField.text = String(format:"%.2f", lastBillAmount)
            }

            if lastBillAmount > 0 {
                hadZeroValue = false
            }
            updateValues()
        }

        applyLightTheme()
    }

    override func viewDidAppear(_animated: Bool) {
        super.viewDidAppear(_animated)

        initializeView()

        billField.becomeFirstResponder()

        updateValues()
    }

    func initializeView() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let first = String(defaults.integerForKey("firstPercentage"))
        let second = String(defaults.integerForKey("secondPercentage"))
        let third = String(defaults.integerForKey("thirdPercentage"))

        tipControl.setTitle(first, forSegmentAtIndex: 0)
        tipControl.setTitle(second, forSegmentAtIndex: 1)
        tipControl.setTitle(third, forSegmentAtIndex: 2)

        let lightTheme = defaults.boolForKey("lightTheme")
        if lightTheme {
            applyLightTheme()
        } else {
            applyDarkTheme()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        updateValues()
    }

    func updateValues() {
        var billAmount = 0.0
        if billField.text != "" {
            billAmount = Double(billField.text!)!
        }

        if billAmount > 0 {
            showView(showPopulatedView, withAnimation: hadZeroValue)
            hadZeroValue = false
        } else {
            showView(showInitialView, withAnimation: !hadZeroValue)
            hadZeroValue = true
        }

        var tipPercentages = [
            Double(tipControl.titleForSegmentAtIndex(0)!)! / 100,
            Double(tipControl.titleForSegmentAtIndex(1)!)! / 100,
            Double(tipControl.titleForSegmentAtIndex(2)!)! / 100
        ]

        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let tip = billAmount * tipPercentage
        let total = billAmount + tip

        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)

        let date = NSDate()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(date, forKey: "dateLastEntered")
        defaults.setDouble(billAmount, forKey: "lastBillAmount")
    }

    func showView(viewFunc: Void -> Void, withAnimation: Bool) {
        if withAnimation {
            UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
                viewFunc()
            }, completion: nil)
        } else {
            viewFunc()
        }
    }

    func showInitialView() {
        var billFieldFrame = self.billField.frame
        billFieldFrame.origin.y = 170
        self.billField.frame = billFieldFrame

        self.lowerSubView.alpha = 0
        var lowerSubViewFrame = self.lowerSubView.frame
        lowerSubViewFrame.origin.y = 500
        self.lowerSubView.frame = lowerSubViewFrame
    }

    func showPopulatedView() {
        var billFieldFrame = self.billField.frame
        billFieldFrame.origin.y = 70
        self.billField.frame = billFieldFrame

        self.lowerSubView.alpha = 1
        var lowerSubViewFrame = self.lowerSubView.frame
        lowerSubViewFrame.origin.y = 150
        self.lowerSubView.frame = lowerSubViewFrame
    }

    func applyDarkTheme() {
        self.viewController.backgroundColor = UIColor.blackColor()
        self.lowerSubView.backgroundColor = UIColor.blackColor()
        self.billField.textColor = UIColor.whiteColor()
        self.billField.tintColor = UIColor.whiteColor()
        self.billField.attributedPlaceholder = NSAttributedString(string:"$",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.tipControl.backgroundColor = UIColor.blackColor()
        self.tipControl.tintColor = UIColor.whiteColor()
        self.tipLabel.textColor = UIColor.whiteColor()
        self.totalLabel.textColor = UIColor.whiteColor()
    }

    func applyLightTheme() {
        self.viewController.backgroundColor = UIColor.whiteColor()
        self.lowerSubView.backgroundColor = UIColor.whiteColor()
        self.billField.textColor = UIColor.blackColor()
        self.billField.tintColor = UIColor.blackColor()
        self.billField.attributedPlaceholder = NSAttributedString(string:"$",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        self.tipControl.backgroundColor = UIColor.whiteColor()
        self.tipControl.tintColor = UIColor.blackColor()
        self.tipLabel.textColor = UIColor.blackColor()
        self.totalLabel.textColor = UIColor.blackColor()
    }
}


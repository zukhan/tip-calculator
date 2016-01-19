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
    @IBOutlet weak var billFieldTopConstraint: NSLayoutConstraint!

    var lightColor = UIColor(red: 0.8902, green: 0.9765, blue: 0.9412, alpha: 1.0)
    var darkColor = UIColor(red: 0.1569, green: 0.2824, blue: 0.3373, alpha: 1.0)
    var tipPercentages = [10, 15, 20]
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

        let now = NSDate()
        let secSinceLastEntered = now.timeIntervalSinceDate(dateLastEntered)
        if secSinceLastEntered < 600 {
            if lastBillAmount == 0 {
                billField.text = ""
            } else if lastBillAmount % 1 == 0 {
                billField.text = String(format:"%d", Int(lastBillAmount))
            } else {
                billField.text = String(format:"%.2f", lastBillAmount)
            }

            recalculateValues()
        }
    }

    override func viewDidAppear(_animated: Bool) {
        super.viewDidAppear(_animated)

        initializeView()

        billField.becomeFirstResponder()

        recalculateValues()
    }

    func initializeView() {
        let defaults = NSUserDefaults.standardUserDefaults()
        for (i, rawTip) in defaults.arrayForKey("tipPercentages")!.enumerate() {
            tipPercentages[i] = rawTip as! Int
        }

        tipControl.setTitle(String(tipPercentages[0]) + "%", forSegmentAtIndex: 0)
        tipControl.setTitle(String(tipPercentages[1]) + "%", forSegmentAtIndex: 1)
        tipControl.setTitle(String(tipPercentages[2]) + "%", forSegmentAtIndex: 2)

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
        recalculateValues()
    }

    func recalculateValues() {
        var billAmount = 0.0
        if billField.text != "" {
            billAmount = Double(billField.text!)!
        }

        if billAmount > 0 && hadZeroValue {
            showView(showPopulatedView)
            hadZeroValue = false
        } else if billAmount == 0 && !hadZeroValue {
            showView(showInitialView)
            hadZeroValue = true
        }

        let tipDecimalPercentages = [
            Double(tipPercentages[0]) / 100,
            Double(tipPercentages[1]) / 100,
            Double(tipPercentages[2]) / 100
        ]

        let tipPercentage = tipDecimalPercentages[tipControl.selectedSegmentIndex]
        let tip = billAmount * tipPercentage
        let total = billAmount + tip

        tipLabel.text = NSNumberFormatter.localizedStringFromNumber(tip, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
        totalLabel.text = NSNumberFormatter.localizedStringFromNumber(total, numberStyle: NSNumberFormatterStyle.CurrencyStyle)

        let date = NSDate()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(date, forKey: "dateLastEntered")
        defaults.setDouble(billAmount, forKey: "lastBillAmount")
    }

    func showView(viewFunc: Void -> Void) {
        UIView.animateWithDuration(0.5, animations: {
            viewFunc()
        })
    }

    func showInitialView() {
        billFieldTopConstraint.constant = 120
        self.lowerSubView.alpha = 0
        self.view.layoutIfNeeded()
    }

    func showPopulatedView() {
        billFieldTopConstraint.constant = 22
        self.lowerSubView.alpha = 1
        self.view.layoutIfNeeded()
    }

    func applyDarkTheme() {
        self.viewController.backgroundColor = darkColor
        self.lowerSubView.backgroundColor = darkColor
        self.billField.textColor = UIColor.whiteColor()
        self.billField.tintColor = UIColor.whiteColor()
        self.billField.attributedPlaceholder = NSAttributedString(string:"$",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.tipControl.backgroundColor = darkColor
        self.tipControl.tintColor = UIColor.whiteColor()
        self.tipLabel.textColor = UIColor.whiteColor()
        self.totalLabel.textColor = UIColor.whiteColor()
    }

    func applyLightTheme() {
        self.viewController.backgroundColor = lightColor
        self.lowerSubView.backgroundColor = lightColor
        self.billField.textColor = UIColor.blackColor()
        self.billField.tintColor = UIColor.blackColor()
        self.billField.attributedPlaceholder = NSAttributedString(string:"$",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        self.tipControl.backgroundColor = lightColor
        self.tipControl.tintColor = UIColor.blackColor()
        self.tipLabel.textColor = UIColor.blackColor()
        self.totalLabel.textColor = UIColor.blackColor()
    }
}


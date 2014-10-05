//
//  ViewController.swift
//  Inflation Calculator
//
//  Created by Cal on 10/4/14.
//  Copyright (c) 2014 Cal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet var dateLeft: UILabel!
    @IBOutlet var dateRight: UILabel!
    @IBOutlet var datePicker: UIPickerView!
    @IBOutlet var leftAmountLabel: UILabel!
    @IBOutlet var leftAmountButton: UIButton!
    @IBOutlet var rightAmountLabel: UILabel!
    @IBOutlet var rightAmountButton: UIButton!
    
    var activeLabel : UILabel? = nil
    var CPI : Array<Float> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load CPI data
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("CPIdata", ofType: "txt")
        let content = String.stringWithContentsOfFile(path!, encoding: NSUTF8StringEncoding, error: nil)
        let strings = content?.componentsSeparatedByString("\n")
        for s in strings!{
            CPI.append(NSString(string: s).floatValue)
        }
        
        activeLabel = leftAmountLabel
        datePicker.delegate = self
        datePicker.selectRow(34, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func numberButtonPressed(sender: UIButton) {
        var currentValue = NSString(string: activeLabel!.text!).floatValue
        currentValue *= 10
        currentValue += Float(sender.titleLabel!.text!.toInt()!)
        activeLabel!.text = "\(currentValue)"
        self.updateAmounts()
    }
    
    @IBAction func pointButtonPressed(sender: UIButton) {
        
    }
    
    func updateAmounts() {
        var activeAmount : Float = NSString(string: activeLabel!.text!).floatValue
        print(activeAmount)
        var inactive : UILabel
        var activeYear : Int
        var inactiveYear : Int
        if(activeLabel == leftAmountLabel){
            activeYear = dateLeft.text!.toInt()!
            inactive = rightAmountLabel
            inactiveYear = dateRight.text!.toInt()!
        }
        else{
            activeYear = dateRight.text!.toInt()!
            inactive = leftAmountLabel
            inactiveYear = dateLeft.text!.toInt()!
        }
        
        var activeCPI = CPI[CPI.count - (2015 - activeYear)]
        var inactiveCPI = CPI[CPI.count - (2015 - inactiveYear)]
        
        var inactiveAmount : Float = activeAmount * (inactiveCPI / activeCPI)
        
        inactive.text = "\(inactiveAmount)"
    }
    
    @IBAction func amountButtonPressed(sender: UIButton) {
        if(sender.tag == 1){ //left button
            activeLabel = leftAmountLabel
            rightAmountButton.backgroundColor = UIColor(red: 70/255, green: 170/255, blue: 118/255, alpha: 1)
            leftAmountButton.backgroundColor = UIColor(red: 70/255, green: 170/255, blue: 118/255, alpha: 0.75)
        }
        else{ //right button
            activeLabel = rightAmountLabel
            leftAmountButton.backgroundColor = UIColor(red: 70/255, green: 170/255, blue: 118/255, alpha: 1)
            rightAmountButton.backgroundColor = UIColor(red: 70/255, green: 170/255, blue: 118/255, alpha: 0.75)
        }
    }
    
    @IBAction func clearButtonPressed(sender: UIButton) {
        leftAmountLabel.text = "$0"
        rightAmountLabel.text = "$0"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return (2014 - 1799)
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String {
        return "\(2014 - row)"
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            dateLeft.text = String(2014 - row)
        }else{
            dateRight.text = String(2014 - row)
        }
        updateAmounts()
    }
    
}


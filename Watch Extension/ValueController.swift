//
//  ValueController.swift
//  Inflation Calculator
//
//  Created by Cal on 1/6/15.
//  Copyright (c) 2015 Cal. All rights reserved.
//

import Foundation
import WatchKit

enum DecimalState {
    case disabled, readyOne, readyTwo, full
}

class ValueController : WKInterfaceController {
    
    var currentValue : Double = 0
    var decimalState : DecimalState = .disabled
    @IBOutlet weak var label: WKInterfaceLabel!
    //green (1) has identityDummy, blue (2) does not
    @IBOutlet weak var identityDummy: WKInterfaceLabel?
    
    override func willActivate() {
        updateLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLabel), name: ICRefreshCurrencyNotification, object: nil)
    }
    
    func numberButtonPressed(_ value: Int){
        if decimalState == .readyOne {
            currentValue += Double(value) / 10
            decimalState = .readyTwo
        }
        else if decimalState == .readyTwo {
            currentValue += Double(value) / 100
            decimalState = .full
        }
        else if decimalState == .disabled{
            if currentValue >= 10_000_000 {
                return
            }
            currentValue *= 10
            currentValue += Double(value)
        }
        updateLabel()
    }
    
    @IBAction func decimalButton() {
        decimalState = .readyOne
        updateLabel()
    }
    
    @IBAction func clearButton() {
        decimalState = .disabled
        currentValue = 0
        updateLabel()
    }
    
    func updateLabel(){
        let decimalCount = (self.decimalState == .disabled ? 0 : 2)
        label.setText(currentValue.format(using: Inflation.Controller.currency, decimalCount: decimalCount))
        
        if identityDummy != nil {
            Inflation.Controller.anchor1 = true
            Inflation.Controller.dollars1 = currentValue
            Inflation.Controller.dollars1HasDecimal = (self.decimalState != .disabled)
            Inflation.Controller.dollars2HasDecimal = true
        } else {
            Inflation.Controller.anchor1 = false
            Inflation.Controller.dollars2 = currentValue
            Inflation.Controller.dollars2HasDecimal = (self.decimalState != .disabled)
            Inflation.Controller.dollars1HasDecimal = true
        }
    }
    
    @IBAction func button1() {
        numberButtonPressed(1)
    }
    
    @IBAction func button2() {
        numberButtonPressed(2)
    }
    
    @IBAction func button3() {
        numberButtonPressed(3)
    }
    
    @IBAction func button4() {
        numberButtonPressed(4)
    }
    
    @IBAction func button5() {
        numberButtonPressed(5)
    }
    
    @IBAction func button6() {
        numberButtonPressed(6)
    }
    
    @IBAction func button7() {
        numberButtonPressed(7)
    }
    
    @IBAction func button8() {
        numberButtonPressed(8)
    }
    
    @IBAction func button9() {
        numberButtonPressed(9)
    }
    
    @IBAction func button0() {
        numberButtonPressed(0)
    }
    
}

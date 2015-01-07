//
//  ValueController.swift
//  Inflation Calculator
//
//  Created by Cal on 1/6/15.
//  Copyright (c) 2015 Cal. All rights reserved.
//

import Foundation
import WatchKit

class ValueController : WKInterfaceController {
    
    var currentValue = 0
    @IBOutlet weak var label: WKInterfaceLabel!
    
    func numberButtonPressed(value: Int){
        currentValue *= 10
        currentValue += value
        label.setText("$\(currentValue)")
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
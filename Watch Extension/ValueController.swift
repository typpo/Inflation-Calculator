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
    
   /*
    override func willActivate() {
        currentValue = (identityDummy != nil ? Inflation.Data.dollars1 : Inflation.Data.dollars2)
        decimalState = .Full
        if currentValue % 0.1 == 0 {
            decimalState = .ReadyTwo
        }
        if currentValue % 1 == 0 {
            decimalState = .Disabled
        }
        updateLabel()
    }
    */
    
    override func didDeactivate() {
        Inflation.Data.checkDataLoaded()
        Inflation.Data.anchor1 = identityDummy != nil
        Inflation.Data.updateValuesForCPI()
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
        label.setText(formatAmount(currentValue, forceDecimal: self.decimalState != .disabled))
        if identityDummy != nil {
            Inflation.Data.dollars1 = currentValue
        } else {
            Inflation.Data.dollars2 = currentValue
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

func formatAmount(_ amount:Double, forceDecimal: Bool = false) -> String {
    return "\(amount)" //maybe try to reimplement using the NSString formatter?
    /*let hasDecimal = amount.truncatingRemainder(dividingBy: 1) != 0
    let floatRounded = String(NSString(format: "%.02f", amount))
    
    let range = floatRounded
    var withoutDecimal = floatRounded.substring(with: range)
    
    
    var pieces : Array<String> = []
    /*while(withoutDecimal.characters.count > 3){
        let index = .index(before: .index(before: withoutDecimal.characters.index(before: withoutDecimal.endIndex)))
        pieces.append(withoutDecimal.substring(from: index))
        withoutDecimal = withoutDecimal.substring(to: index)
    }*/
    pieces.append(withoutDecimal)
    
    pieces = Array(pieces.reversed())
    var moneyFormatted = pieces[0]
    if(pieces.count > 1){
        for i in 1...(pieces.count - 1){
            moneyFormatted += ",\(pieces[i])"
        }
    }
    
    if (hasDecimal || forceDecimal) {
        moneyFormatted += floatRounded.substring(from: range.upperBound)
    }
    
    return "$\(moneyFormatted)"*/
}

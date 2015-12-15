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
    case Disabled, ReadyOne, ReadyTwo, Full
}

class ValueController : WKInterfaceController {
    
    var currentValue : Double = 0
    var decimalState : DecimalState = .Disabled
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
    
    func numberButtonPressed(value: Int){
        if decimalState == .ReadyOne {
            currentValue += Double(value) / 10
            decimalState = .ReadyTwo
        }
        else if decimalState == .ReadyTwo {
            currentValue += Double(value) / 100
            decimalState = .Full
        }
        else if decimalState == .Disabled{
            if currentValue >= 10_000_000 {
                return
            }
            currentValue *= 10
            currentValue += Double(value)
        }
        updateLabel()
    }
    
    @IBAction func decimalButton() {
        decimalState = .ReadyOne
        updateLabel()
    }
    
    @IBAction func clearButton() {
        decimalState = .Disabled
        currentValue = 0
        updateLabel()
    }
    
    func updateLabel(){
        label.setText(formatAmount(currentValue, forceDecimal: self.decimalState != .Disabled))
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

func formatAmount(amount:Double, forceDecimal: Bool = false) -> String {
    let hasDecimal = amount % 1 != 0
    let floatRounded = String(NSString(format: "%.02f", amount))
    
    let range = Range<String.Index>(start: floatRounded.startIndex, end: floatRounded.endIndex.predecessor().predecessor().predecessor())
    var withoutDecimal = floatRounded.substringWithRange(range)
    
    
    var pieces : Array<String> = []
    while(withoutDecimal.characters.count > 3){
        let index = withoutDecimal.endIndex.predecessor().predecessor().predecessor()
        pieces.append(withoutDecimal.substringFromIndex(index))
        withoutDecimal = withoutDecimal.substringToIndex(index)
    }
    pieces.append(withoutDecimal)
    
    pieces = Array(pieces.reverse())
    var moneyFormatted = pieces[0]
    if(pieces.count > 1){
        for i in 1...(pieces.count - 1){
            moneyFormatted += ",\(pieces[i])"
        }
    }
    
    if (hasDecimal || forceDecimal) {
        moneyFormatted += floatRounded.substringFromIndex(range.endIndex)
    }
    
    return "$\(moneyFormatted)"
}
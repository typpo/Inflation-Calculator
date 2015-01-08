//
//  YearController.swift
//  Inflation Calculator
//
//  Created by Cal on 1/6/15.
//  Copyright (c) 2015 Cal. All rights reserved.
//

import Foundation
import WatchKit

class YearController : WKInterfaceController {
    
    var year : String = "1980"
    
    @IBOutlet weak var valueLabel: WKInterfaceButton!
    @IBOutlet weak var centuryLabel: WKInterfaceLabel!
    @IBOutlet weak var decadeLabel: WKInterfaceLabel!
    @IBOutlet weak var yearLabel: WKInterfaceLabel!
    
    @IBOutlet weak var centurySlider: WKInterfaceSlider!
    @IBOutlet weak var decadeSlider: WKInterfaceSlider!
    @IBOutlet weak var yearSlider: WKInterfaceSlider!
    
    @IBAction func centuryUpdated(float: Float) {
        let value = Int(float)
        year = "\(value)" + year.substringWithRange(Range<String.Index>(start: advance(year.startIndex, 2), end: year.endIndex))
        centuryLabel.setText("\(value)")
        updateLabel()
    }
    
    @IBAction func decadeUpdated(float: Float) {
        let value = Int(float)
        year = year.substringWithRange(Range<String.Index>(start: year.startIndex, end: advance(year.endIndex, -2))) + "\(value)" + year.substringWithRange(Range<String.Index>(start: advance(year.startIndex, 3), end: year.endIndex))
        decadeLabel.setText("\(value)")
        updateLabel()
    }
    
    @IBAction func yearUpdated(float: Float) {
        let value = Int(float)
        year = year.substringWithRange(Range<String.Index>(start: year.startIndex, end: advance(year.endIndex, -1))) + "\(value)"
        yearLabel.setText("\(value)")
        updateLabel()
    }
    
    func updateLabel() {
        valueLabel.setTitle(year)
        
        if year.toInt()! > 2015 {
            year = "2015"
            decadeLabel.setText("1")
            yearLabel.setText("5")
            decadeSlider.setValue(1)
            yearSlider.setValue(5)
            updateLabel()
        }
    }
    
}
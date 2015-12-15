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
    
    @IBOutlet weak var centuryLabel: WKInterfaceLabel!
    @IBOutlet weak var decadeLabel: WKInterfaceLabel!
    @IBOutlet weak var yearLabel: WKInterfaceLabel!
    @IBOutlet var yearPicker: WKInterfacePicker!
    
    @IBOutlet weak var centurySlider: WKInterfaceSlider!
    @IBOutlet weak var decadeSlider: WKInterfaceSlider!
    @IBOutlet weak var yearSlider: WKInterfaceSlider!
    //green (1) has identityDummy, blue (2) does not
    @IBOutlet weak var identityDummy: WKInterfaceLabel?
    
    override func willActivate() {
        if identityDummy != nil {
            year = "\(Inflation.Data.year1)"
        } else {
            year = "\(Inflation.Data.year2)"
            centurySlider.setColor(UIColor(red: 10/255, green: 85/255, blue: 119/255, alpha: 1))
            decadeSlider.setColor(UIColor(red: 10/255, green: 85/255, blue: 119/255, alpha: 1))
            yearSlider.setColor(UIColor(red: 10/255, green: 85/255, blue: 119/255, alpha: 1))
        }
        
        updateSlidersForYear(Int(year)!)
        
        //set up year picker
        var pickerItems: [WKPickerItem] = []
        for year in 1800...2016 {
            let item = WKPickerItem()
            item.title = "\(year)"
            pickerItems.insert(item, atIndex: 0)
        }
        yearPicker.setItems(pickerItems)
        yearPicker.setSelectedItemIndex(2016 - Int(year)!)

    }

    override func didDeactivate() {
        Inflation.Data.checkDataLoaded()
        Inflation.Data.updateValuesForCPI()
    }
    
    @IBAction func centuryUpdated(float: Float) {
        let value = Int(float)
        year = "\(value)" + year.substringWithRange(Range<String.Index>(start: year.startIndex.advancedBy(2), end: year.endIndex))
        centuryLabel.setText("\(value)")
        updateLabel()
    }
    
    @IBAction func decadeUpdated(float: Float) {
        let value = Int(float)
        year = year.substringWithRange(Range<String.Index>(start: year.startIndex, end: year.endIndex.advancedBy(-2))) + "\(value)" + year.substringWithRange(Range<String.Index>(start: year.startIndex.advancedBy(3), end: year.endIndex))
        decadeLabel.setText("\(value)")
        updateLabel()
    }
    
    @IBAction func yearUpdated(float: Float) {
        let value = Int(float)
        year = year.substringWithRange(Range<String.Index>(start: year.startIndex, end: year.endIndex.advancedBy(-1))) + "\(value)"
        yearLabel.setText("\(value)")
        updateLabel()
    }
    
    func updateLabel() {
        yearPicker.setSelectedItemIndex(2016 - Int(year)!)
        
        if Int(year)! > 2016 {
            year = "2016"
            decadeLabel.setText("1")
            yearLabel.setText("6")
            decadeSlider.setValue(1)
            yearSlider.setValue(6)
            updateLabel()
        }
        
        updateSavedYear()
    }
    
    @IBAction func yearPicked(value: Int) {
        let selectedYear = 2016 - value
        year = "\(selectedYear)"
        updateSlidersForYear(selectedYear)
        updateSavedYear()
    }
    
    func updateSlidersForYear(year: Int) {
        let yearValue = year % 10
        let decadeValue = (year - yearValue) / 10 % 10
        let centuryValue = (year - yearValue - decadeValue) / 100
        
        yearLabel.setText("\(yearValue)")
        yearSlider.setValue(Float(yearValue))
        decadeLabel.setText("\(decadeValue)")
        decadeSlider.setValue(Float(decadeValue))
        centuryLabel.setText("\(centuryValue)")
        centurySlider.setValue(Float(centuryValue))
    }
    
    func updateSavedYear() {
        if identityDummy != nil {
            Inflation.Data.year1 = Int(year)!
        } else {
            Inflation.Data.year2 = Int(year)!
        }
    }
    
}
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
        updateForCurrency()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateForCurrency), name: ICRefreshCurrencyNotification, object: nil)
    }
    
    func updateForCurrency() {
        Inflation.Controller.clampYearsToCurrencyRange()
        
        if identityDummy != nil {
            year = "\(Inflation.Controller.year1)"
        } else {
            year = "\(Inflation.Controller.year2)"
            centurySlider.setColor(UIColor(red: 10/255, green: 85/255, blue: 119/255, alpha: 1))
            decadeSlider.setColor(UIColor(red: 10/255, green: 85/255, blue: 119/255, alpha: 1))
            yearSlider.setColor(UIColor(red: 10/255, green: 85/255, blue: 119/255, alpha: 1))
        }
        
        updateSlidersForYear(Int(year)!)
        
        //set up year picker
        let minYear = Inflation.Controller.currency.earliestYear
        let maxYear = Inflation.Controller.currency.mostRecentYear
        
        var pickerItems: [WKPickerItem] = []
        for year in minYear...maxYear {
            let item = WKPickerItem()
            item.title = "\(year)"
            pickerItems.insert(item, at: 0)
        }
        
        yearPicker.setItems(pickerItems)
        yearPicker.setSelectedItemIndex(maxYear - Int(year)!)
    }
    
    @IBAction func centuryUpdated(_ float: Float) {
        let value = Int(float)
        year = "\(value)" + year.substring(with: (year.characters.index(year.startIndex, offsetBy: 2) ..< year.endIndex))
        centuryLabel.setText("\(value)")
        updateLabel()
    }
    
    @IBAction func decadeUpdated(_ float: Float) {
        let value = Int(float)
        year = year.substring(with: (year.startIndex ..< year.characters.index(year.endIndex, offsetBy: -2))) + "\(value)" + year.substring(with: (year.characters.index(year.startIndex, offsetBy: 3) ..< year.endIndex))
        decadeLabel.setText("\(value)")
        updateLabel()
    }
    
    @IBAction func yearUpdated(_ float: Float) {
        let value = Int(float)
        year = year.substring(with: (year.startIndex ..< year.characters.index(year.endIndex, offsetBy: -1))) + "\(value)"
        yearLabel.setText("\(value)")
        updateLabel()
    }
    
    func updateLabel() {
        let minYear = Inflation.Controller.currency.earliestYear
        let maxYear = Inflation.Controller.currency.mostRecentYear
        
        yearPicker.setSelectedItemIndex(maxYear - Int(year)!)
        
        if Int(year)! > maxYear {
            year = "\(maxYear)"
            updateSlidersForYear(maxYear)
            updateLabel()
        }
        
        else if Int(year)! < minYear {
            year = "\(minYear)"
            updateSlidersForYear(minYear)
            updateLabel()
        }
        
        updateSavedYear()
    }
    
    @IBAction func yearPicked(_ value: Int) {
        let selectedYear = Inflation.Controller.currency.mostRecentYear - value
        year = "\(selectedYear)"
        updateSlidersForYear(selectedYear)
        updateSavedYear()
    }
    
    func updateSlidersForYear(_ year: Int) {
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
            Inflation.Controller.year1 = Int(year)!
        } else {
            Inflation.Controller.year2 = Int(year)!
        }
    }
    
}

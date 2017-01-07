//
//  Controller.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/7/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import WatchKit

class Inflation {
    
    struct Controller {
        static var mainInterface : InterfaceController? = nil
        
        static var dollars1 : Double = 0
        static var dollars1HasDecimal = false
        
        static var dollars2 : Double = 0
        static var dollars2HasDecimal = false
        
        static var year1 : Int = 1980
        static var year2 : Int = 2017
        
        static var anchor1: Bool = true
        
        static var currency: Currency {
            let index = UserDefaults.standard.integer(forKey: "currencyIndex")
            
            if index < 0 || index >= Currency.all.count {
                return .usDollar
            }
            
            return Currency.all[index]
        }
        
        static func clampYearsToCurrencyRange() {
            let minYear = Inflation.Controller.currency.earliestYear
            let maxYear = Inflation.Controller.currency.mostRecentYear
            
            func clamped(_ year: Int) -> Int {
                return Int(min(maxYear, max(minYear, year)))
            }
            
            Inflation.Controller.year1 = clamped(Inflation.Controller.year1)
            Inflation.Controller.year2 = clamped(Inflation.Controller.year2)
        }
        
        static func updateValuesForCPI(){
            clampYearsToCurrencyRange()
            
            var anchorAmount = dollars1
            var anchorYear = year1
            var modifyAmount = dollars2
            var modifyYear = year2
            
            if !anchor1 {
                anchorAmount = dollars2
                anchorYear = year2
                modifyAmount = dollars1
                modifyYear = year1
            }
            
            let currency = Inflation.Controller.currency
            modifyAmount = currency.calculateInflation(of: anchorAmount, from: anchorYear, to: modifyYear) ?? 0.0
            
            if anchor1 {
                dollars2 = modifyAmount
            } else {
                dollars1 = modifyAmount
            }
            
            Inflation.Controller.updateLabels(anchor1: anchor1)
            
            WKInterfaceDevice.current().play(WKHapticType.click)
        }
        
        static func updateLabels(anchor1 : Bool) {
            mainInterface?.year1Button.setTitle("\(Inflation.Controller.year1)")
            mainInterface?.year2Button.setTitle("\(Inflation.Controller.year2)")
            
            let currency = Inflation.Controller.currency
            
            let dollars1Text = Inflation.Controller.dollars1.format(using: currency, decimalCount: (Inflation.Controller.dollars1HasDecimal ? 2 : 0))
            mainInterface?.dollars1Button.setTitle(dollars1Text)
            
            let dollars2Text = Inflation.Controller.dollars2.format(using: currency, decimalCount: (Inflation.Controller.dollars2HasDecimal ? 2 : 0))
            mainInterface?.dollars2Button.setTitle(dollars2Text)
        }
        
        static func giveMainInterface(_ interface : InterfaceController){
            mainInterface = interface
        }
    }
    
}

//
//  InterfaceController.swift
//  Inflation Calc WatchKit Extension
//
//  Created by Cal on 1/6/15.
//  Copyright (c) 2015 Cal. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var dollars1Button: WKInterfaceButton!
    @IBOutlet weak var dollars2Button: WKInterfaceButton!
    @IBOutlet weak var year1Button: WKInterfaceButton!
    @IBOutlet weak var year2Button: WKInterfaceButton!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
    }
    
    override func willActivate() {
        super.willActivate()
        Inflation.Data.giveInterface(self)
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}

class Inflation {
    
    struct Data {
        static var mainInterface : InterfaceController? = nil
        static var CPI : [Double] = []
        static var dollars1 : Double = 0
        static var dollars2 : Double = 0
        static var year1 : Int = 1980
        static var year2 : Int = 2016
        
        static var anchor1: Bool = true
        
        static func updateValuesForCPI(){
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
            let anchorCPI = CPI[CPI.count - (2017 - anchorYear)]
            let modifyCPI = CPI[CPI.count - (2017 - modifyYear)]
            modifyAmount = anchorAmount * (modifyCPI / anchorCPI)
            if anchor1 {
                dollars2 = modifyAmount
            } else {
                dollars1 = modifyAmount
            }
            updateLabels(anchor1: anchor1)
            
            WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Click)
        }
        
        static func checkDataLoaded() {
            if CPI.count == 0 {
                let bundle = NSBundle.mainBundle()
                let path = bundle.pathForResource("CPIdata", ofType: "txt")
                let content = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
                
                let strings = content.componentsSeparatedByString("\n")
                for s in strings {
                    CPI.append(NSString(string: s).doubleValue)
                }
            }
        }
        
        static func updateLabels(anchor1 anchor1 : Bool) {
            mainInterface?.year1Button.setTitle("\(Inflation.Data.year1)")
            mainInterface?.year2Button.setTitle("\(Inflation.Data.year2)")
            mainInterface?.dollars1Button.setTitle("\(formatAmount(Inflation.Data.dollars1))")
            mainInterface?.dollars2Button.setTitle("\(formatAmount(Inflation.Data.dollars2))")
        }
        
        static func giveInterface(interface : InterfaceController){
            mainInterface = interface
        }
    }
    
}
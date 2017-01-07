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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func willActivate() {
        super.willActivate()
        Inflation.Controller.giveMainInterface(self)
        self.updateCurrency()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCurrency), name: ICRefreshCurrencyNotification, object: nil)
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func updateCurrency() {
        Inflation.Controller.updateValuesForCPI()
    }

}

//
//  User.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/6/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import UIKit

class User {
    
    private enum Key : String, UserDefaultsKey {
        case currencyIndex = "User.currencyIndex"
        case currencyUpgradePurchased = "User.currencyUpgradePurchased"
    }
    
    static let current = User()
    
    private init() { }
    
    
    //MARK: - Currency
    
    var currency: Currency {
        guard let index = UserDefaults.standard.get(Key.currencyIndex) as? Int else {
            return .usDollar
        }
        
        if index < 0 || index >= Currency.all.count {
            return .usDollar
        }
        
        return Currency.all[index]
    }
    
    func updateCurrency(to index: Int) {
        UserDefaults.standard.update(Key.currencyIndex, to: index)
    }
    
    
    //MARK: - Upgrades
    
    //FIXME: remove temp
    private let purchasedKey = "UserHasPurchased-temp2"
    
    var hasPurchasedCurrencyUpgrade: Bool {
        get {
            guard let string = UserDefaults.standard.get(Key.currencyUpgradePurchased) as? String else { return false }
            return string == self.purchasedKey
        }
        set(newValue) {
            let valueToStore = (newValue) ? self.purchasedKey : nil
            UserDefaults.standard.update(Key.currencyUpgradePurchased, to: valueToStore)
            UserDefaults.standard.synchronize()
        }
    }
    
}




//MARK: - UserDefaults + Key

protocol UserDefaultsKey {
    var rawValue: String { get }
}

extension UserDefaults {
    
    func update(_ key: UserDefaultsKey, to value: Any?) {
        self.set(value, forKey: key.rawValue)
        self.synchronize()
    }
    
    func get(_ key: UserDefaultsKey) -> Any? {
        return self.object(forKey: key.rawValue)
    }
    
}

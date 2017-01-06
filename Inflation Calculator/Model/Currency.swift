//
//  Currency.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/2/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import UIKit

typealias Year = Int
typealias CPI = Double

struct Currency {
    
    //defined currencies
    static let usDollar = Currency(named: "US Dollar", symbol: "$", flag: "🇺🇸")
    static let euro = Currency(named: "Euro", symbol: "€", flag: "🇪🇺")
    static let britishPound = Currency(named: "British Pound", symbol:  "£", flag: "🇬🇧")
    static let japaneseYen = Currency(named: "Japanese Yen", symbol: "¥", flag: "🇯🇵")
    
    static let all = [usDollar, euro, britishPound, japaneseYen].flatMap { $0 }
    
    //properties
    
    let name: String
    let flag: String
    let symbol: String
    
    let data: [Year : CPI]
    let years: [Year]
    
    init?(named name: String, symbol: String, flag: String) {
        self.name = name
        self.symbol = symbol
        self.flag = flag
        
        //load data dictionary from CSV
        guard let dataURL = Bundle.main.url(forResource: "Currencies/\(name)", withExtension: "csv"),
            let dataText = try? String(contentsOf: dataURL) else {
                return nil
        }
        
        var data = [Year : CPI]()
        
        let dataLines = dataText.components(separatedBy: "\r\n")
        for line in dataLines {
            let components = line.components(separatedBy: ",")
            if let year = Int(components[0]), let cpi = Double(components[1]) {
                data[year] = cpi
            }
        }
        
        if data.count == 0 {
            return nil
        }
        
        self.data = data
        self.years = Array(data.keys).sorted().reversed()
    }
    
    
    //MARK: - Calculations
    
    var earliestYear: Year {
        return years.first!
    }
    
    var mostRecentYear: Year {
        return years.last!
    }
    
    func cpi(for year: Year) -> CPI? {
        return data[year]
    }
    
    func calculateInflation(of value: Double, from year1: Year, to year2: Year) -> Double? {
        guard let cpi1 = cpi(for: year1), let cpi2 = cpi(for: year2) else { return nil }
        return (cpi2 / cpi1) * value
    }

}

extension Double {
    
    func format(using currency: Currency, decimalCount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        let usdFormat = formatter.string(from: NSNumber(value: self))
        let currencyFormatted = usdFormat?.replacingOccurrences(of: "$", with: currency.symbol)
        
        guard let stringWithDecimal = currencyFormatted else { return "\(currency.symbol)--" }
        let numberComponents = stringWithDecimal.components(separatedBy: ".")
        
        if decimalCount == 0 {
            return numberComponents[0]
        }
        
        if decimalCount == 1 {
            let firstDecimal = numberComponents[1].characters.first ?? Character("0")
            return "\(numberComponents[0]).\(firstDecimal)"
        }
        
        //currency decimals max out at 2 digits
        return stringWithDecimal
    }
    
}

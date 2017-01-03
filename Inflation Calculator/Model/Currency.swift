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
    
    let name: String
    let id: String
    let symbol: String
    
    let data: [Year : CPI]
    let years: [Year]
    
    init?(named name: String, id: String, symbol: String) {
        self.name = name
        self.id = id
        self.symbol = symbol
        
        //load data dictionary from CSV
        guard let dataURL = Bundle.main.url(forResource: "Currencies/\(id)", withExtension: "csv"),
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
        let currencyFormatted = usdFormat?.replacingOccurrences(of: "$ ", with: currency.symbol)
        return currencyFormatted ?? "\(currency.symbol)--"
    }
    
}

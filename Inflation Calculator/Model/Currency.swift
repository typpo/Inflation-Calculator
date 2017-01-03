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
    
    init?(named name: String, id: String, symbol: String) {
        self.name = name
        self.id = id
        self.symbol = symbol
        
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
    }
    
    
    //MARK: - Calculations
    
    var earliestYear: Year {
        return Array(data.keys).min()! //safe because data will always have atleast one item
    }
    
    var mostRecentYear: Year {
        return Array(data.keys).max()!
    }
    
    func cpi(for year: Year) -> CPI? {
        return data[year]
    }
    
    func calculateInflation(of value: Double, from year1: Year, to year2: Year) -> Double? {
        guard let cpi1 = cpi(for: year1), let cpi2 = cpi(for: year2) else { return nil }
        return (cpi2 / cpi1) * value
    }

}

//
//  Currency.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/2/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import Foundation

typealias Year = Int
typealias CPI = Double

struct Currency {
    
    
    //MARK: - Defined Currencies
    
    static let usDollar = Currency(named: "US Dollar", symbol: "$", flag: "🇺🇸")
    static let euro = Currency(named: "Euro", symbol: "€", flag: "🇪🇺")
    static let britishPound = Currency(named: "British Pound", symbol:  "£", flag: "🇬🇧")
    static let japaneseYen = Currency(named: "Japanese Yen", symbol: "¥", flag: "🇯🇵")
    static let canadianDollar = Currency(named: "Canadian Dollar", symbol: "$", flag: "🇨🇦")
    static let swissFranc = Currency(named: "Swiss Franc", symbol: "Fr", flag: "🇨🇭")
    static let chineseYuan = Currency(named: "Chinese Yuan", symbol: "¥", flag: "🇨🇳")
    static let swedishKrona = Currency(named: "Swedish Krona", symbol: "kr", flag: "🇸🇪")
    static let mexicanPeso = Currency(named: "Mexican Peso", symbol: "$", flag: "🇲🇽")
    static let norwegianKrone = Currency(named: "Norwegian Krone", symbol: "kr", flag: "🇳🇴")
    static let southKoreanWon = Currency(named: "South Korean Won", symbol: "₩", flag: "🇰🇷")
    static let turkishLira = Currency(named: "Turkish Lira", symbol: "₺", flag: "🇹🇷")
    static let brazilianReal = Currency(named: "Brazilian Real", symbol: "R$", flag: "🇧🇷")
    static let southAfricanRand = Currency(named: "South African Rand", symbol: "R", flag: "🇿🇦")
    static let indianRupee = Currency(named: "Indian Rupee", symbol: "₹", flag: "🇮🇳")
    static let russianRuble = Currency(named: "Russian Ruble", symbol: "₽", flag: "🇷🇺")
    static let israeliSheqel = Currency(named: "Israeli Sheqel", symbol: "₪", flag: "🇮🇱")
    static let indonesianRupiah = Currency(named: "Indonesian Rupiah", symbol: "Rp", flag: "🇮🇩")
    
    static let all = [usDollar, euro, britishPound, japaneseYen, canadianDollar,
                      swissFranc, chineseYuan, swedishKrona, mexicanPeso, norwegianKrone,
                      southKoreanWon, turkishLira, brazilianReal, southAfricanRand,
                      indianRupee, russianRuble, israeliSheqel, indonesianRupiah]
    
    
    //MARK: - Properties
    
    let name: String
    let flag: String
    let symbol: String
    
    let data: [Year : CPI]
    let years: [Year]
    
    private init(named name: String, symbol: String, flag: String) {
        self.name = name
        self.symbol = symbol
        self.flag = flag
        
        //load data dictionary from CSV
        let dataURL = Bundle.main.url(forResource: "Currencies/\(name)", withExtension: "csv")!
        let dataText = try! String(contentsOf: dataURL)
        
        var data = [Year : CPI]()
        
        let dataLines = dataText.components(separatedBy: "\r\n")
        for line in dataLines {
            let components = line.components(separatedBy: ",")
            if let year = Int(components[0]), let cpi = Double(components[1]) {
                data[year] = cpi
            }
        }
        
        self.data = data
        self.years = Array(data.keys).sorted().reversed()
    }
    
    
    //MARK: - Calculations
    
    var earliestYear: Year {
        return years.last!
    }
    
    var mostRecentYear: Year {
        return years.first!
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
        
        let prefix = (currency.symbol.characters.count >= 2)
                      ? "\(currency.symbol) "
                      : currency.symbol
        
        let usdFormat = formatter.string(from: NSNumber(value: self))
        let currencyFormatted = usdFormat?.replacingOccurrences(of: "$", with: prefix)
        
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

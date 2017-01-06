//
//  CurrencyViewController.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/5/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import UIKit

class CurrencyViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let identifier = "currencySelector"
    
    static func present(over presenter: UIViewController, completion: ((Currency?) -> ())?) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CurrencyViewController.identifier) as! CurrencyViewController
        controller.completion = completion
        
        presenter.present(controller, animated: true, completion: nil)
    }
    
    
    var completion: ((Currency?) -> ())? = nil
    
    
    //MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Currency.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.identifier, for: indexPath)
            
        if let cell = cell as? CurrencyCell {
            let currency = Currency.all[indexPath.item]
            let evenIndex = indexPath.item % 2 == 0
            let symbolColor = (evenIndex) ? #colorLiteral(red: 0.1568627451, green: 0.6078431373, blue: 0.3960784314, alpha: 1) : #colorLiteral(red: 0.1058823529, green: 0.4980392157, blue: 0.7098039216, alpha: 1)
            
            cell.decorate(for: currency, symbolColor: symbolColor)
        }
        
        return cell
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func dismiss() {
        self.completion?(nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = Currency.all[indexPath.item]
        self.completion?(currency)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

class CurrencyCell : UITableViewCell {
    
    static let identifier = "currencyCell"
    
    @IBOutlet weak var symbolView: CircleView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var flagLabel: UILabel!
    
    func decorate(for currency: Currency, symbolColor: UIColor) {
        symbolView.backgroundColor = symbolColor
        symbolLabel.text = currency.symbol
        nameLabel.text = currency.name
        flagLabel.text = currency.flag
        
        rangeLabel.text = "Data from \(currency.earliestYear) to \(currency.mostRecentYear)"
    }
    
}

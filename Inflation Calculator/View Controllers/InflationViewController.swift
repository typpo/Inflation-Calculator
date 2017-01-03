//
//  ViewController.swift
//  Inflation Calculator
//
//  Created by Cal on 10/4/14.
//  Copyright (c) 2015 Cal. All rights reserved.
//

import UIKit

class InflationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var leftDollarsLabel: UILabel!
    @IBOutlet weak var leftDollarsView: UIView!
    @IBOutlet weak var rightDollarsLabel: UILabel!
    @IBOutlet weak var rightDollarsView: UIView!
    @IBOutlet weak var leftYearsView: UIView!
    @IBOutlet weak var leftYearsLabel: UILabel!
    @IBOutlet weak var rightYearsLabel: UILabel!
    @IBOutlet weak var rightYearsView: UIView!
    
    var currency = Currency(named: "US Dollar", id: "USD", symbol: "$")
    
    //MARK: - View Setup
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureNavbar()
    }
    
    func configureNavbar() {
        removeHairline(from: self.navigationController)
        
        guard let bar = self.navigationController?.navigationBar else { return }
        
        let existingTitleLabel = bar.subviews.first(where: {
            ($0 as? UILabel)?.text == "Inflation Calculator"
        })
        
        if existingTitleLabel == nil {
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = "Inflation Calculator"
            titleLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFontWeightMedium)
            titleLabel.textColor = .white
            
            titleLabel.layer.shadowOffset = CGSize(width: 4, height: 2)
            titleLabel.layer.shadowColor = UIColor.black.cgColor
            titleLabel.layer.shadowRadius = 3.0
            titleLabel.layer.shadowOpacity = 0.1
            
            bar.addSubview(titleLabel)
            
            titleLabel.centerXAnchor.constraint(equalTo: bar.centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: bar.centerYAnchor).isActive = true
            titleLabel.layoutIfNeeded()
        }
        
    }
    
    func removeHairline(from navivgationController: UINavigationController?) {

        func findHairline(under view: UIView?) -> UIView? {
            guard let view = view else { return nil }
            
            if view.isKind(of: UIImageView.self) && view.bounds.size.height <= 1.0 {
                return view
            }
            
            for subview in view.subviews {
                return findHairline(under: subview)
            }
            
            return nil
        }
        
        let hairline = findHairline(under: navigationController?.navigationBar)
        hairline?.alpha = 0.0
    }
    
    
    //MARK: - Picker View delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributes: [String : AnyObject] = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20.0),
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        return NSAttributedString(string: "1980", attributes: attributes)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32.0
    }
    

}

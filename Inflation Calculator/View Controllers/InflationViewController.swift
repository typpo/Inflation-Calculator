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
    @IBOutlet weak var leftYearView: UIView!
    @IBOutlet weak var leftYearLabel: UILabel!
    @IBOutlet weak var rightYearLabel: UILabel!
    @IBOutlet weak var rightYearView: UIView!
    
    @IBOutlet weak var currencyView: UIStackView!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet var numberKeys: [UIView]!
    @IBOutlet var interactiveViews: [UIView]!
    
    var currency = Currency(named: "US Dollar", id: "USD", symbol: "$")
    
    //MARK: - View Setup
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureNavbar()
        
        self.currentDollarsView = leftDollarsView
        self.currentDollarsLabel = leftDollarsLabel
        self.currentYearView = leftYearView
        self.currentYearLabel = leftYearLabel
        
        self.otherDollarsView = rightDollarsView
        self.otherDollarsLabel = rightDollarsLabel
        self.otherYearView = rightYearView
        self.otherYearLabel = rightYearLabel
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
    
    
    //MARK: - User Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch(at: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch(at: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch(at: touches, finishes: true, performsAction: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch(at: touches, finishes: true)
    }
    
    func touch(at touches: Set<UITouch>, finishes: Bool = false, performsAction: Bool = false) {
        guard let touch = touches.first?.location(in: self.view) else { return }
        
        for view in self.interactiveViews {
            
            //check if view contains touch when
            let existingTransform = view.transform
            view.transform = .identity
            let touchInView = self.view.convert(touch, to: view)
            let viewContainsTouch = view.bounds.contains(touchInView)
            view.transform = existingTransform
            
            //view animation
            if viewContainsTouch && !finishes {
                
                let transform: CGAffineTransform
                
                if self.numberKeys.contains(view) {
                    transform = CGAffineTransform(scaleX: 0.875, y: 0.875)
                } else if view == currencyView {
                    transform = CGAffineTransform(translationX: 10.0, y: 0.0)
                } else {
                    transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }
                
                UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    view.transform = transform
                }, completion: nil)
            }
            
            else {
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    view.transform = .identity
                }, completion: nil)
            }
            
            //perform actions
            if viewContainsTouch && performsAction {
                
                if self.numberKeys.contains(view) {
                    self.numberButtonPressed(view)
                } else {
                    self.auxillaryButtonPressed(view)
                }
                
            }
        }
    }
    
    
    //MARK: - Manage Views and Labels
    
    var currentDollarValue: Double = 0.0
    var leftYear: Year = 1980
    var rightYear: Year = 2017
    
    var otherDollarValue: Double {
        guard let currency = self.currency else { return currentDollarValue }
        return currency.calculateInflation(of: currentDollarValue, from: currentYear, to: otherYear) ?? currentDollarValue
    }
    
    var currentYear: Year {
        return (currentYearView == self.leftYearView) ? leftYear : rightYear
    }
    
    var otherYear: Year {
        return (currentYearView == self.leftYearView) ? rightYear : leftYear
    }
    
    var currentDollarsLabel: UILabel!
    var currentDollarsView: UIView!
    var currentYearLabel: UILabel!
    var currentYearView: UIView!
    
    var otherDollarsLabel: UILabel!
    var otherDollarsView: UIView!
    var otherYearLabel: UILabel!
    var otherYearView: UIView!
    
    let unselectedColor = UIColor(red: 0.188, green: 0.619, blue: 0.396, alpha: 1.0)
    let selectedDollarsColor = UIColor(red: 0.055, green: 0.412, blue: 0.220, alpha: 1.0)
    let selectedYearColor = UIColor(red: 0.071, green: 0.514, blue: 0.302, alpha: 1.0)
    
    func numberButtonPressed(_ view: UIView) {
        guard let labelText = view.subviews.flatMap({ $0 as? UILabel }).first?.text else { return }
        
        if let labelNumber = Double(labelText) {
            currentDollarValue *= 10
            currentDollarValue += labelNumber
        } else {
            
        }
        
        updateLabels()
    }
    
    func updateLabels() {
        self.currentYearLabel.text = "\(currentYear)"
        self.otherYearLabel.text = "\(otherYear)"
        
        guard let currency = self.currency else { return }
        currentDollarsLabel.text = currentDollarValue.format(using: currency, decimalCount: 0)
        otherDollarsLabel.text = otherDollarValue.format(using: currency, decimalCount: 2)
    }
    
    func auxillaryButtonPressed(_ view: UIView) {
        if view == otherDollarsView || view == otherYearView {
            swapViews()
            updateViewColors()
            
            self.currentDollarValue = self.otherDollarValue
            updateLabels()
        }
    }
    
    func swapViews() {
        swap(&currentDollarsLabel, &otherDollarsLabel)
        swap(&currentDollarsView, &otherDollarsView)
        swap(&currentYearLabel, &otherYearLabel)
        swap(&currentYearView, &otherYearView)
    }
    
    func updateViewColors() {
        self.currentDollarsView.backgroundColor = self.selectedDollarsColor
        self.currentYearView.backgroundColor = self.selectedYearColor
        self.otherDollarsView.backgroundColor = self.unselectedColor
        self.otherYearView.backgroundColor = self.unselectedColor
    }
    
    
    //MARK: - Picker View delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency?.years.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32.0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let year = currency?.years[row] else { return NSAttributedString(string: "--") }
        return NSAttributedString(string: "\(year)", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20.0),
            NSForegroundColorAttributeName : UIColor.white
        ])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let year = currency?.years[row] {
            if component == 0 {
                self.leftYear = year
            } else {
                self.rightYear = year
            }
        }
        
        self.updateLabels()
    }
    

}

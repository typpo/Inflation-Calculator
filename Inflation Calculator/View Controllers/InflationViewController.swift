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
    @IBOutlet weak var currencyTouchView: UIView!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet var numberKeys: [UIView]!
    @IBOutlet var interactiveViews: [UIView]!
    
    var currency = Currency.usDollar
    
    
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
        
        self.updateCurrency(to: User.currency)
        self.setYears(targetingOnLeft: 1980, targetingOnRight: 2017)
        self.updateLabels()
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
    
    //this method is a hot mess but it'll do
    func touch(at touches: Set<UITouch>, finishes: Bool = false, performsAction: Bool = false) {
        guard let touch = touches.first?.location(in: self.view) else { return }
        
        for view in self.interactiveViews {
            
            //check if view contains touch when
            let existingTransform = view.transform
            view.transform = .identity
            let touchInView = self.view.convert(touch, to: view)
            let viewContainsTouch = view.bounds.contains(touchInView)
            view.transform = existingTransform
            
            var viewToAnimate = view
            
            if view == self.currencyTouchView {
                viewToAnimate = self.currencyView
            }
            
            //view animation
            if viewContainsTouch && !finishes {
                
                let transform: CGAffineTransform
    
                if self.numberKeys.contains(viewToAnimate) {
                    transform = CGAffineTransform(scaleX: 0.875, y: 0.875)
                } else if viewToAnimate == self.currencyView {
                    transform = CGAffineTransform(scaleX: 0.875, y: 0.875)
                } else {
                    transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }
                
                UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    viewToAnimate.transform = transform
                }, completion: nil)
            }
            
            else {
                let delay = (viewToAnimate == self.currencyView) ? 0.5 : 0.0
                
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    viewToAnimate.transform = .identity
                }, completion: nil)
            }
            
            //perform actions
            if viewContainsTouch && performsAction {
                
                if self.numberKeys.contains(view) {
                    self.numberButtonPressed(view)
                } else if view == self.currencyTouchView {
                    CurrencyViewController.present(over: self, completion: self.updateCurrency)
                } else {
                    self.auxillaryButtonPressed(view)
                }
                
            }
        }
    }
    
    
    //MARK: - Manage Views and Labels
    
    var currentDollarValue: Double = 0.0
    var decimalModeEnabled = false
    var decimalCount = 0
    
    var leftYear: Year = 1980
    var rightYear: Year = 2017
    
    var otherDollarValue: Double {
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
    
    let unselectedColor = #colorLiteral(red: 0.1568627954, green: 0.6078432202, blue: 0.3960783482, alpha: 1)
    let selectedYearColor = #colorLiteral(red: 0.003163533518, green: 0.5039576292, blue: 0.3017136455, alpha: 1)
    let selectedDollarsColor = #colorLiteral(red: 0.01015596557, green: 0.4034596086, blue: 0.2193256021, alpha: 1)
    
    func updateCurrency(toCurrencyAtIndex index: Int?) {
        if let index = index {
            User.updateCurrency(to: index)
            
            let currency = Currency.all[index]
            self.updateCurrency(to: currency)
        }
    }
    
    func updateCurrency(to currency: Currency) {
        self.currency = currency
        
        self.currencyLabel.text = currency.name
        self.currencySymbol.text = currency.symbol
        
        self.updateLabels()
        self.pickerView.reloadAllComponents()
    }
    
    func setYears(targetingOnLeft leftTargetYear: Year, targetingOnRight rightTargetYear: Year) {
        
        //returns the actual year selected
        func update(label: UILabel, toTarget targetYear: Year) -> Year? {
            if currency.years.contains(targetYear) {
                label.text = "\(targetYear)"
                return targetYear
            }
            
            //find year with the smallest difference between target year
            let closestExistingYear = currency.years.min(by: { choice1, choice2 in
                let difference1 = abs(targetYear - choice1)
                let difference2 = abs(targetYear - choice2)
                return difference1 < difference2
            })
            
            if let year = closestExistingYear {
                label.text = "\(year)"
            } else {
                label.text = "--"
            }
            
            return closestExistingYear
        }
        
        func apply(year: Year, toPickerSegment segment: Int) {
            guard let index = self.currency.years.index(of: year) else { return }
            pickerView.selectRow(index, inComponent: segment, animated: false)
        }
        
        if let newLeft = update(label: self.leftYearLabel, toTarget: leftTargetYear) {
            self.leftYear = newLeft
            apply(year: newLeft, toPickerSegment: 0)
        }
        
        if let newRight = update(label: self.rightYearLabel, toTarget: rightTargetYear) {
            self.rightYear = newRight
            apply(year: newRight, toPickerSegment: 1)
        }
    }
    
    func numberButtonPressed(_ view: UIView) {
        guard let labelText = view.subviews.flatMap({ $0 as? UILabel }).first?.text else { return }
        
        if let labelNumber = Double(labelText) {
            
            if self.currentDollarValue >= 99_999_999_999_999 {
                //gotta max-out eventually
                return
            }
            
            if !decimalModeEnabled {
                currentDollarValue *= 10
                currentDollarValue += labelNumber
            }
            
            else { //if decimalModeEnabled
                if self.decimalCount == 2 {
                    clearCurrentInput()
                    numberButtonPressed(view) //process the touch again with decimalMode disabled
                } else {
                    self.decimalCount += 1
                    self.currentDollarValue += Double(labelNumber) / pow(10, Double(self.decimalCount))
                }
            }
            
            updateLabels()
        }
        
        //clear button
        else if labelText == "c" {
            clearCurrentInput()
        }
        
        //decimal button
        else if labelText == "." {
            self.decimalModeEnabled = true
            updateLabels()
        }
    }
    
    func clearCurrentInput() {
        self.currentDollarValue = 0
        self.decimalCount = 0
        self.decimalModeEnabled = false
        updateLabels()
    }
    
    func updateLabels() {
        self.currentYearLabel.text = "\(currentYear)"
        
        let decimalDisplayCount = (self.decimalModeEnabled) ? 2 : 0
        currentDollarsLabel.text = currentDollarValue.format(using: self.currency, decimalCount: decimalDisplayCount)
        
        otherDollarsLabel.text = otherDollarValue.format(using: self.currency, decimalCount: 2)
    }
    
    func auxillaryButtonPressed(_ view: UIView) {
        if view == otherDollarsView || view == otherYearView {
            self.currentDollarValue = self.otherDollarValue
            self.decimalCount = 2
            self.decimalModeEnabled = true
            
            swapViews()
            updateViewColors()
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
        return self.currency.years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32.0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let year = self.currency.years[row]
        return NSAttributedString(string: "\(year)", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20.0),
            NSForegroundColorAttributeName : UIColor.white
        ])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = self.currency.years[row]
        
        if component == 0 {
            self.leftYear = year
        } else {
            self.rightYear = year
        }
        
        self.updateLabels()
    }
    
}

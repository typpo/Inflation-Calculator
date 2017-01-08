//
//  UpgradeViewController.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/6/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import UIKit
import StoreKit

class UpgradeViewController : UIViewController {
    
    
    //MARK: - Presentation
    
    static let identifier = "upgrade"
    
    static func present(over presenter: UIViewController) {
        guard let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: UpgradeViewController.identifier) as? UpgradeViewController else { return }
        presenter.present(controller, animated: true, completion: nil)
    }
    
    
    //MARK: - Setup
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var product: SKProduct?
    var productLoaded = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        
        //decrease stack view spacing on small screens (4S / iPad in compatability mode)
        if self.view.frame.height < 500 {
            mainStackView.spacing = 15.0
        }
        
        StoreManager.main.requestProduct(withIdentifier: .allCurrencies) { product in
            self.productLoaded = true
            
            if let product = product {
                self.product = product
                
                let formatter = NumberFormatter()
                formatter.locale = product.priceLocale
                formatter.numberStyle = .currency
                
                self.titleLabel.text = product.localizedTitle
                self.priceLabel.text = formatter.string(from: product.price)
            }
        }
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewFullList() {
        CurrencyViewController.present(over: self, allowSelection: false, completion: nil)
    }
    
    
    //MARK: - Purchase Flow
    
    @IBAction func purchase() {
        self.purchase(andWait: true)
    }
    
    func purchase(andWait wait: Bool) {
        if !StoreManager.main.userCanMakePayments {
            self.showAlert(title: "Cannot purchase upgrade", message: "Your Apple ID is not able to make payments. This may be due to parental controls or missing payment information.")
            return
        }
        
        if !self.productLoaded && wait {
            let alert = UIAlertController(title: "One Moment", message: "Loading your purchases", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                alert.dismiss(animated: true, completion: {
                    self.purchase(andWait: false)
                })
            })
            
            return
        }
        
        guard let product = self.product, self.productLoaded else {
            self.showAlert(title: "Cannot Connect to the App Store", message: "We're having trouble connecting to the App Store. Are you connected to the internet?")
            return
        }
        
        StoreManager.main.purchase(product, completion: { success in
            if !success {
                self.showAlert(title: "Could Not Complete Purchase", message: "We were unable to complete your purchase. This may be due to insufficient funds on your account.")
            } else {
                self.purchaseSuccessful()
            }
        })
    }
    
    @IBAction func restore() {
        StoreManager.main.restorePurchases(triggerCompletionFor: .allCurrencies, completion: { success in
            if !success {
                self.showAlert(title: "Could Not Restore Purchase", message: "You have not previously purchased this item. If this is incorrect, please send an email to cal@calstephens.tech.")
            } else {
                self.purchaseSuccessful()
            }
        })
    }
    
    func purchaseSuccessful() {
        let presentingViewController = self.presentingViewController
        
        self.dismiss(animated: true, completion: { _ in
            if let presenter = presentingViewController as? NavigationController {
                if let inflationController = presenter.viewControllers.first as? InflationViewController {
                    inflationController.presentCurrencySelector()
                }
            }
        })
    }
    
    
    func showAlert(title: String, message: String, handler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler?()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

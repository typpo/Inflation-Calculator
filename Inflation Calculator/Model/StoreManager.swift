//
//  TransactionObserver.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/6/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import StoreKit

enum StoreIdentifier: String {
    case allCurrencies = "currencies"
}

class StoreManager : NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    static let main = StoreManager()
    
    private override init() { }
    
    var userCanMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    //MARK: - SKProductsRequestDelegate
    
    var productRequestCompletions = [SKProductsRequest : (SKProduct?) -> ()]()
    
    func requestProduct(withIdentifier identifier: StoreIdentifier, completion: @escaping (SKProduct?) -> ()) {
        let identifiers = Set(arrayLiteral: identifier.rawValue)
        let request = SKProductsRequest(productIdentifiers: identifiers)
        
        request.delegate = self
        productRequestCompletions.updateValue(completion, forKey: request)
        
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let completion = productRequestCompletions[request]
        productRequestCompletions.removeValue(forKey: request)
        completion?(response.products.first)
    }
    
    
    //MARK: - SKPayment
    
    var paymentCompletions = [SKPayment : (Bool) -> ()]()
    
    func purchase(_ product: SKProduct, completion: ((Bool) -> ())?) {
        completion?(true)
        return
        
        let payment = SKPayment(product: product)
        
        if let completion = completion {
            paymentCompletions.updateValue(completion, forKey: payment)
        }
        
        SKPaymentQueue.default().add(payment)
    }
    
    
    //MARK: - SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            let payment = transaction.payment
            let completion = self.paymentCompletions[payment]
            self.paymentCompletions.removeValue(forKey: payment)
            
            if let completion = completion {
                if transaction.transactionState == .purchased || transaction.transactionState == .restored {
                    completion(true)
                }
                    
                else if transaction.transactionState == .failed {
                    completion(false)
                }
            }
            
        }
        
    }
    
}

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
    
    var paymentCompletions = [String : (Bool) -> ()]()
    
    func purchase(_ product: SKProduct, completion: @escaping (Bool) -> ()) {
        let payment = SKPayment(product: product)
        paymentCompletions.updateValue(completion, forKey: product.productIdentifier)
        
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases(triggerCompletionFor identifier: StoreIdentifier, completion: @escaping (Bool) -> ()) {
        paymentCompletions.updateValue(completion, forKey: identifier.rawValue)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    //MARK: - SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            let payment = transaction.payment
            print(payment.productIdentifier)
            print(self.paymentCompletions)
            
            func callCompletion(with value: Bool) {
                let completion = self.paymentCompletions[payment.productIdentifier]
                self.paymentCompletions.removeValue(forKey: payment.productIdentifier)
                completion?(value)
            }
            
            if transaction.transactionState == .purchased || transaction.transactionState == .restored {
                
                if payment.productIdentifier == StoreIdentifier.allCurrencies.rawValue {
                    User.current.hasPurchasedCurrencyUpgrade = true
                }
                
                callCompletion(with: true)
                queue.finishTransaction(transaction)
            }
                
            else if transaction.transactionState == .failed {
                callCompletion(with: false)
                queue.finishTransaction(transaction)
            }
            
        }
        
    }
    
}

//
//  AppDelegate.swift
//  Inflation Calculator
//
//  Created by Cal on 10/4/14.
//  Copyright (c) 2014 Cal. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.appBecameVisible()
        
        //prepare to listen for IAPs
        SKPaymentQueue.default().add(StoreManager.main)

        return true
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.appBecameVisible()
    }
    
    func appBecameVisible() {
        User.current.numberOfAppLaunches += 1
        print(User.current.numberOfAppLaunches)
        
        if User.current.isEligableForRateAlert {
            guard let navigation = window?.rootViewController else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
                RateViewController.present(over: navigation)
            }
        }
    }

}


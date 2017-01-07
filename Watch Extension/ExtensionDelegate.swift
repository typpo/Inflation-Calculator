//
//  ExtensionDelegate.swift
//  Watch Extension
//
//  Created by Cal on 12/14/15.
//  Copyright © 2015 Cal. All rights reserved.
//

import WatchConnectivity
import WatchKit

let ICRefreshCurrencyNotification = NSNotification.Name("ICRefreshCurrencyNotification")

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    
    //MARK: - Listen for Currency Changes
    
    var session: WCSession = WCSession.default()
    
    func applicationDidFinishLaunching() {
        session.delegate = self
        session.activate()
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation Complete")
    }
    
    //I really love WatchConnectivity now ::
    //if the user changes their currency when the watch app is closed,
    //the watch app receives the update as soon as the app opens
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Received Application Context::")
        for (key, value) in applicationContext {
            print("\(key) = \(value)")
            UserDefaults.standard.set(value, forKey: key)
        }
        
        NotificationCenter.default.post(name: ICRefreshCurrencyNotification, object: nil)
    }
    
}

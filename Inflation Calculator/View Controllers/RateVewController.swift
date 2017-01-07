//
//  RateVewController.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/7/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import UIKit

class RateViewController : UIViewController {
    
    
    //MARK: - Presentation
    
    static let identifier = "rate"
    
    static func present(over presenter: UIViewController) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: RateViewController.identifier) as? RateViewController else { return }
        controller.modalPresentationStyle = .overCurrentContext
        presenter.present(controller, animated: false, completion: nil)
    }
    
    
    //MARK: - Setup
    
    @IBOutlet weak var scrim: UIView!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var contents1Center: NSLayoutConstraint!
    @IBOutlet weak var contents2Center: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        scrim.alpha = 0.0
        card.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrim.alpha = 1.0
        })
        
        card.alpha = 1.0
        card.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height * 0.75)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            self.card.transform = .identity
        }, completion: nil)
    }
    
    func dismissCard(animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.scrim.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseIn], animations: {
            self.card.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height * 0.75)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func noButtonPressed() {
        self.dismissCard(animated: true)
        User.current.neverShowRateAlert = true
    }
    
    @IBAction func lovePressed() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.contents1Center.constant = -self.view.frame.width * 0.75
            self.contents2Center.constant = 0
            self.card.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func laterPressed() {
        self.dismissCard(animated: true)
    }
    
    @IBAction func rateConfirmationPressed() {
        User.current.hasRatedApp = true
        UIApplication.shared.openURL(URL(string: "itms-apps://appsto.re/us/Wyip3.i")!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.dismissCard(animated: false)
        }
    }
    
}

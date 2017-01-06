//
//  CircleView.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/5/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView : UIView {
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
    
}

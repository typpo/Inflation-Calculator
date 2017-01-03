//
//  SelectCornerRadiusView.swift
//  Inflation Calculator
//
//  Created by Cal Stephens on 1/2/17.
//  Copyright © 2017 Cal. All rights reserved.
//

import UIKit

@IBDesignable
class SelectCornerRadiusView : UIView {
    
    @IBInspectable var topLeft: Bool = true
    @IBInspectable var topRight: Bool = true
    @IBInspectable var bottomLeft: Bool = true
    @IBInspectable var bottomRight: Bool = true
    
    @IBInspectable var cornerRadius: Double = -1
    
    override func draw(_ rect: CGRect) {
        let mask = CAShapeLayer()
        let radius = CGSize(width: CGFloat(cornerRadius), height: CGFloat(cornerRadius))
        var corners: UIRectCorner = []
        
        if topLeft { corners.formSymmetricDifference(.topLeft) }
        if topRight { corners.formSymmetricDifference(.topRight) }
        if bottomLeft { corners.formSymmetricDifference(.bottomLeft) }
        if bottomRight { corners.formSymmetricDifference(.bottomRight) }
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radius)
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

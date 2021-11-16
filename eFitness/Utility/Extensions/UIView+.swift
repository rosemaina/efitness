//
//  UIView+.swift
//  eFitness
//
//  Created by Rose Maina on 01/11/2021.
//

import UIKit

extension UIView {
    func addCornerRadiusAndShadow(_ cornerRadius: CGFloat = 10,
                                  _ shadowSize: CGFloat = 1,
                                  _ shadowColor: CGColor = UIColor.black.cgColor,
                                  _ shadowOpacity: CGFloat = 0.16,
                                  _ shadowsRadius: CGFloat = 1.0) {
        layer.cornerRadius = cornerRadius
        addShadow(shadowSize, shadowColor, shadowOpacity, shadowsRadius)
    }
    
    func addCornerRadius(_ radius: CGFloat = 10) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func addShadow(_ size: CGFloat = 1,
                   _ shadowColor: CGColor,
                   _ shadowOpacity: CGFloat,
                   _ shadowsRadius: CGFloat) {
        layer.shadowColor = shadowColor
        layer.shadowRadius = shadowsRadius
        layer.shadowOffset = CGSize(width: size, height: size)
        layer.shadowOpacity = Float(shadowOpacity)
    }
    
    func addCornerRadius(_ corners: UIRectCorner, _ radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addBorder(_ color: UIColor, width: CGFloat = 1.0) {
        layer.cornerRadius = frame.size.height / 2
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func makeConstraints(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, topMargin: CGFloat, leftMargin: CGFloat, rightMargin: CGFloat, bottomMargin: CGFloat, width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topMargin).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftMargin).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -rightMargin).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomMargin).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach{ addSubview($0) }
    }
}

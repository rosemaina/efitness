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
    
    func addSubviews(_ views: UIView...) {
        views.forEach{ addSubview($0) }
    }
    
    static func shadowedCard(_ backgroundColor: UIColor = .white) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cellShadow()
        view.backgroundColor = backgroundColor
        
        return view
    }
    
    static func createView(_ backgroundColor: UIColor = .white) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor

        return view
    }
}

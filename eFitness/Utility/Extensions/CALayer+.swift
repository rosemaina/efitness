//
//  CALayer+.swift
//  eFitness
//
//  Created by Rose Maina on 21/11/2021.
//

import UIKit

extension CALayer {
    
    func addShadow(withRadius radius: CGFloat, xOffset: CGFloat = 0, yOffset: CGFloat = 1) {
        cornerRadius = radius
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: xOffset, height: yOffset)
        shadowOpacity = 0.16
    }
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
            
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case .right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
    
    func cellShadow() {
        addShadow(withRadius: 4)
    }
}

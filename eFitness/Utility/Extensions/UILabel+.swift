//
//  UILabel+.swift
//  eFitness
//
//  Created by Rose Maina on 21/11/2021.
//

import UIKit

extension UILabel {
    
    static func createLabel(title: String,
                            textColor: UIColor = .black,
                            font: UIFont = Fonts.montserratSemiBold(12),
                            alignment: NSTextAlignment = .left,
                            lineBreakMode: NSLineBreakMode = .byWordWrapping) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = alignment
        label.textColor = textColor
        label.font = font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}

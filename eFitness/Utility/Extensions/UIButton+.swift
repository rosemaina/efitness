//
//  UIButton+.swift
//  eFitness
//
//  Created by Rose Maina on 21/11/2021.
//

import UIKit

extension UIButton {
    static func createButton(title: String, backgroundColor: UIColor, textColor: UIColor, borderColor: UIColor) -> UIButton {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 20
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = Fonts.montserratSemiBold(15)
        return button
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

//
//  UIColor+.swift
//  eFitness
//
//  Created by Rose Maina on 01/11/2021.
//

import UIKit

struct Colors {
    static let background = UIColor(hexString: "#F7F7F7")
    static let pantone11c = UIColor(hexString: "#A7A9AC")
    static let actionRed = UIColor(hexString: "#EA0029")
    static let titleGreen = UIColor(hexString: "#3FA626")
    
    static let darkGreen = UIColor(hexString: "#027D55")
    static let backgroundGreen = UIColor(hexString: "#DFFFF0")
    static let inactiveGray = UIColor(hexString: "#C6C6C8")
    static let tabbarGreen = UIColor(hexString: "#63C46A")    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF

        // swiftlint:disable identifier_name
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        // swiftlint:enable identifier_name

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

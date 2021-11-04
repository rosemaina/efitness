//
//  UIFont+.swift
//  eFitness
//
//  Created by Rose Maina on 01/11/2021.
//

import UIKit

struct Fonts {
    
    static var montserratBold = { (_ size: CGFloat) -> UIFont in
        return UIFont(name: "Montserrat-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static var montserratLight = { (_ size: CGFloat) -> UIFont in
        return UIFont(name: "Montserrat-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static var montserratMedium = { (_ size: CGFloat) -> UIFont in
        return UIFont(name: "Montserrat-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static var montserratSemiBold = { (_ size: CGFloat) -> UIFont in
        return UIFont(name: "Montserrat-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static var montserratRegular = { (_ size: CGFloat) -> UIFont in
        return UIFont(name: "Montserrat-Regular", size: size) ?? .systemFont(ofSize: size)
    }
}

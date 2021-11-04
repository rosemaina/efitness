//
//  UITextField+.swift
//  eFitness
//
//  Created by Rose Maina on 01/11/2021.
//

import UIKit

extension UITextField {
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard(_ title: String = "") {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.setTitleTextAttributes([.font: Fonts.montserratLight(12),
                                     .foregroundColor: Colors.titleGreen], for: .normal)
        let titleText = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.doneButtonAction))
       titleText.setTitleTextAttributes([.font: Fonts.montserratLight(12),
                                           .foregroundColor: Colors.titleGreen], for: .normal)
        
        let items = [titleText,flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc
    func doneButtonAction() {
        self.resignFirstResponder()
    }
}

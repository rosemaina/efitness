//
//  TextfieldValidator.swift
//  eFitness
//
//  Created by Rose Maina on 01/11/2021.
//

import Foundation

protocol Validator {
    func isEmailValid(_ email: String?) -> Bool
    func isPasswordValid(_ password: String?) -> Bool
}

class TextFieldValidator: Validator {
    
    func isEmailValid(_ email: String?) -> Bool {
        guard let email = email else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = email.trimmingCharacters(in: .whitespaces)
        let strippedEmail = trimmedString.replacingOccurrences(of: " ", with: "")
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: strippedEmail)
        
        if !isValidateEmail {
            return false
        }
        
        if email.isEmpty {
            return false
        }
        
        return isValidateEmail
    }
    
    func isPasswordValid(_ password: String?) -> Bool {
        guard let password = password else { return false }
        
        // Min 8 - Max 10 characters with at least 1 Uppercase, 1 Lowercase, 1 Number and 1 Special Character
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,10}"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let strippedPassword = trimmedString.replacingOccurrences(of: " ", with: "")
        let validatePassword = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        let isPasswordValid = validatePassword.evaluate(with: strippedPassword)
        
        if !isPasswordValid {
            return false
        }
        
        if password.isEmpty {
            return false
        }
        
        return isPasswordValid
    }
}

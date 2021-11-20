//
//  User.swift
//  eFitness
//
//  Created by Rose Maina on 20/11/2021.
//

import Foundation

class User: NSObject {
    var name: String?
    var email: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}

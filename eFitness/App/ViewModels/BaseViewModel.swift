//
//  BaseViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase

class BaseViewModel: NSObject {
    
    var roofReference: DatabaseReference {
        return  Database.database().reference()
    }
    
    override init() {
        super.init()
    }
}

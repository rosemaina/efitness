//
//  BaseViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase

class BaseViewModel {
    var currentUser : User? {
        return Auth.auth().currentUser
    }
    
    let client: EfitnessClient
    
    init(client: EfitnessClient) {
        self.client = client
    }
    
    
}

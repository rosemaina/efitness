//
//  BaseViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase

class BaseViewModel {
    
    let client: EfitnessClient
    
    init(client: EfitnessClient) {
        self.client = client
    }
    
    
}

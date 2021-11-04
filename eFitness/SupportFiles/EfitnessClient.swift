//
//  EfitnessClient.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase

class EfitnessClient {
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    static let databaseRef = Database.database().reference() // Gets a FIRDatabaseReference for the root of your Firebase Database
}

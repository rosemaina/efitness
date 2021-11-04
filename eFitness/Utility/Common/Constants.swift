//
//  Constants.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase

let DB_REF = Database.database().reference()
let USERS_REF = DB_REF.child("users")
let userDefaults = UserDefaults.standard

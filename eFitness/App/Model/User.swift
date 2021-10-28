//
//  User.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase

struct User {
  let uid: String
  let email: String

  init(authData: Firebase.User) {
    uid = authData.uid
    email = authData.email ?? ""
  }

  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}

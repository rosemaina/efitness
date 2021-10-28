//
//  BaseViewController.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase
import UIKit

class BaseViewController: UIViewController {
    
    var user: User?
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleUserState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        removeAuthObserver()
    }
    
    func handleUserState() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
          guard let user = user else { return }
          self.user = User(authData: user)
        }
    }
    
    func removeAuthObserver() {
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}

//
//  HomeScene.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase
import UIKit

class HomeScene: UIViewController {

    var viewModel: HomeViewModel?
    
    @IBOutlet weak var viewFeedbackButton: UIButton!
    @IBOutlet weak var caremaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func viewFeedbackButtonTapped() {
        print("present FeedbackViewController")
    }
    
    @IBAction func caremaButtonTapped() {
       print("Present Camera View Controller")
    }
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value) { (snapshot) in
            print("Getting here")
//            guard let username = snapshot.value as? String else { return }
//            self.welcomeLabel.text = "Welcome, \(username)"
            
//            UIView.animate(withDuration: 0.5, animations: {
//                self.welcomeLabel.alpha = 1
//            })
        }
    }
}

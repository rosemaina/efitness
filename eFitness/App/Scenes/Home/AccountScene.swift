//
//  AccountScene.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase
import UIKit

class AccountScene: UIViewController {
    
    var viewModel: HomeViewModel?
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleSignOut() {
        confirmLogoutAlert()
    }
    
    func confirmLogoutAlert() {
        let message = "Are you sure you want to logout?"
        let alertController = UIAlertController(title: "Logout", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            do {
                try Auth.auth().signOut()
                let scene = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginScene")
                self.present(scene, animated: true, completion: nil)
            } catch let signOutError as NSError {
                self.presentErrorAlert(message: signOutError as! String)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

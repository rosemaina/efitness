//
//  ProfileScene.swift
//  eFitness
//
//  Created by Rose Maina on 20/11/2021.
//

import Firebase
import UIKit

class ProfileScene: UIViewController {
    
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var updateProfileButton: UIButton!
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var heightTextfield: UITextField!
    @IBOutlet weak var weightTextfield: UITextField!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews() {
        viewModel = HomeViewModel()

        updateProfileButton.addCornerRadiusAndShadow()
        
        emailTextfield.keyboardType = .emailAddress
        ageTextfield.keyboardType = .numberPad
        heightTextfield.keyboardType = .numberPad
        weightTextfield.keyboardType = .numberPad
        
        nameTextfield.addDoneButtonOnKeyboard()
        emailTextfield.addDoneButtonOnKeyboard()
        ageTextfield.addDoneButtonOnKeyboard()
        heightTextfield.addDoneButtonOnKeyboard()
        weightTextfield.addDoneButtonOnKeyboard()
        
        hideKeyboard()
    }
    
    @IBAction func backBtnTapped() {
        let scene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountScene") as! AccountScene
        scene.modalPresentationStyle = .fullScreen
        self.present(scene, animated: true, completion: nil)
    }
    
    @IBAction func logoutUser() {
        confirmLogoutAlert()
    }
    
    @IBAction func deleteUserAccount() {
        deleteAccountConfirmAlert()
    }
    
    @IBAction func updateUserProfile() {
        print("updated user profile successfully")
    }
    
    func confirmLogoutAlert() {
        let message = "Are you sure you want to logout?"
        let alertController = UIAlertController(title: "Logout", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            do {
                try Auth.auth().signOut()
                let scene = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginScene")
                scene.modalPresentationStyle = .fullScreen
                self.present(scene, animated: true, completion: nil)
            } catch let signOutError as NSError {
                self.presentErrorAlert(message: signOutError as! String)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAccountConfirmAlert() {
        let message = "You are about to delete your account. Do you wish to continue?"
        let alertController = UIAlertController(title: "Delete Account", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let continueAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.deleteAccountAlert()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAccountAlert() {
        let message = "Are you sure you want to delete your account?"
        let alertController = UIAlertController(title: "Delete Account", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            print("account has been deleted successfully")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

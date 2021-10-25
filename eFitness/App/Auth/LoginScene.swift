//
//  LoginScene.swift
//  eFitness
//
//  Created by Rose Maina on 20/10/2021.
//

import Firebase
import UIKit
class LoginScene: UIViewController {
    
    // MARK: - Instance Properties
    var viewModel: LoginViewModel?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginUserAction() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        loginUser(email: email, password: password)
    }
    
    // MARK: - Private Instance Methods
    private func loginUser(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error as NSError? {
                
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed, .userDisabled:
                    self.presentAlertController(withMessage: "Operation Not Allowed. Please contact system administrator.")
                case .invalidEmail, .wrongPassword:
                    self.presentAlertController(withMessage: "Invalid credentials. Please confirm your email amd password.")
                default:
                    self.presentAlertController(withMessage: "Error: \(error.localizedDescription)")
                }
            } else {
                guard let isEmailVerified = authResult?.user.isEmailVerified else { return }
                
                if !isEmailVerified {
                    self.sendVerificationEmail()
                }
                
                self.presentHomeViewController()
            }
        }
    }
    
    func presentHomeViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeScene") as! HomeScene
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func sendVerificationEmail() {
        guard let viewModel = viewModel, let currentUser = viewModel.currentUser else { return }
        
        if !currentUser.isEmailVerified {
            currentUser.sendEmailVerification { error in
                if let error = error {
                    self.presentBaseErrorAlert(message: "\(error.localizedDescription)")
                } else {
                    self.presentAlertController(withMessage: "Email verification link has been sent to your email account")
                }
            }
        } else {
            self.presentBaseErrorAlert(message: "Operation could not be completed.\nPlease check if your email is correct.")
        }
    }
}

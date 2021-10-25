//
//  RegisterScene.swift
//  eFitness
//
//  Created by Rose Maina on 20/10/2021.
//

import Firebase
import UIKit

class RegisterScene: UIViewController {
    
    // MARK: - Instance Properties
    var viewModel: RegisterViewModel?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfields()
    }
    
    @IBAction func registerUserAction() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let username = passwordTextField.text
        else { return }
        
        registerUser(email: email, password: password, username: username)
    }
    
    @IBAction func presentSignIn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginScene") as! LoginScene
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private Instance Methods
    
    private func setupTextfields() {
        emailTextField.keyboardType = .emailAddress
    }
    
    private func presentHomeViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeScene") as! HomeScene
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}

// MARK: - Firebase Methods
extension RegisterScene {
    
    private func registerUser(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    self.presentAlertController(withMessage: "Operation Not Allowed. Ensure email and password is correct.")
                case .emailAlreadyInUse:
                    self.presentAlertController(withMessage: "Email already in use. Try a different email.")
                case .invalidEmail:
                    self.presentAlertController(withMessage: "Invalid Email. Check if your email is correct.")
                case .weakPassword:
                    self.presentCustomAlert(title: "Weak Password", message: "Password should be 8 or more characters. Include number, special character, small leeter and capital letter.")
                default:
                    self.presentAlertController(withMessage: "Error: \(error.localizedDescription)")
                }
            } else {
                guard let currentUser = authResult?.user,
                      let isEmailVerified = authResult?.user.isEmailVerified
                else { return }
                
                if !isEmailVerified {
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

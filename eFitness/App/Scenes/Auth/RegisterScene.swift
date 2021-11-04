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
        configureViews()
    }
    
    // MARK: - Instance Methods
    @IBAction func handleUserRegistration() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let username = passwordTextField.text
        else { return }
        
        registerUser(email: email, password: password, username: username)
    }
    
    @IBAction func presentLoginScene() {
        self.presentLogin()
    }
    
    // MARK: - Private Methods
    func configureViews() {
        viewModel = RegisterViewModel()

        signUpButton.isEnabled = false
        signUpButton.addCornerRadiusAndShadow()
        emailTextField.keyboardType = .emailAddress
        emailTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
        usernameTextField.addDoneButtonOnKeyboard()
        
        hideKeyboard()
    }
    
    func presentLogin() {
        let scene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginScene") as! LoginScene
        self.present(scene, animated: true, completion: nil)
    }
    
    func presentSuccessRegistrationAlert() {
        let message = "An email verification link has been sent to your email. Please confirm your email and login."
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Continue", style: .default) { _ in
            self.presentLogin()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Firebase Methods
extension RegisterScene {
    
    private func registerUser(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    self.presentErrorAlert(message: "Operation Not Allowed. Ensure email and password is correct.")
                case .emailAlreadyInUse:
                    self.presentErrorAlert(message: "Email already in use. Try a different email.")
                case .invalidEmail:
                    self.presentErrorAlert(message: "Invalid Email. Check if your email is correct.")
                case .weakPassword:
                    self.presentErrorAlert(message: "Password should be 8 or more characters. Include number, special character, small leeter and capital letter.")
                default:
                    self.presentErrorAlert(message: "\(error.localizedDescription)")
                }
            } else {
                self.sendVerificationEmail(authResult)
            }
        }
    }
    
    private func sendVerificationEmail(_ authResult: AuthDataResult?) {
        guard let currentUser = authResult?.user else { return }
        UserDefaults.standard.setValue(false, forKey: "isEmailVerified")
        
        if !currentUser.isEmailVerified {
            currentUser.sendEmailVerification { error in
                if let error = error {
                    self.presentErrorAlert(message: "\(error.localizedDescription)")
                } else {
                    UserDefaults.standard.setValue(true, forKey: "isEmailVerified")
                    self.presentSuccessRegistrationAlert()
                }
            }
        } else {
            self.presentErrorAlert(message: "User does not exist or is already verified.")
        }
    }
}

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
    var handle: AuthStateDidChangeListenerHandle?
    let segueIdentifier = "LoginToTab"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        handleLoginState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    // MARK: - Public Instance Methods
    
    @IBAction func loginTapped() {
        self.loginUser()
    }
    
    @IBAction func signInTapped() {
        self.registerUser()
    }
    
    // MARK: Private Instance Methods
    private func setupTextfields() {
        emailTextField.keyboardType = .emailAddress
    }
    
    func presentHomeTab() {
        self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        
//        guard let storyBoard = storyboard else { return }
//        let feedbackVC = storyBoard.instantiateViewController(withIdentifier: "FeedbackScene")
//        let cameraVC = storyBoard.instantiateViewController(withIdentifier: "CameraScene")
//        let accountVC = storyBoard.instantiateViewController(withIdentifier: "AccountScene")
//
//        let tabBarVC = UITabBarController()
//        tabBarVC.viewControllers = [feedbackVC, cameraVC, accountVC]
//        self.presentview
    }
    
    func clearTextfields() {
        self.emailTextField.text = nil
        self.passwordTextField.text = nil
    }
    
    func handleLoginState() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            if user == nil {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.presentHomeTab()
                self.clearTextfields()
            }
        }
    }
}

// MARK: - Firebase Methods
extension LoginScene {
    
    private func registerUser() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    self.presentAlertController(withMessage: "Operation Not Allowed. Ensure email and password is correct.")
                case .emailAlreadyInUse:
                    self.presentAlertController(withMessage: "Email already in use. Try a different email.")
                case .invalidEmail:
                    self.presentAlertController(withMessage: "Invalid Email. Check if your email is correct.")
                case .weakPassword:
                    self.presentAlertController(withMessage: "Password should be 8 or more characters. Include number, special character, small leeter and capital letter.")
                default:
                    self.presentAlertController(withMessage: "Error: \(error.localizedDescription)")
                }
            } else {
                Auth.auth().signIn(withEmail: email, password: password)
            }
        }
    }
    
    private func loginUser() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error as NSError? {
                
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed, .userDisabled:
                    self.presentAlertController(withMessage: "Operation Not Allowed. Please contact system administrator.")
                case .invalidEmail, .wrongPassword:
                    self.presentAlertController(withMessage: "Invalid credentials. Please confirm your email amd password.")
                default:
                    self.presentCustomAlert(title: "Sign In Failed", message: "\(error.localizedDescription)")
                }
            }
        }
    }
    
//    else {
//        guard let isEmailVerified = authResult?.user.isEmailVerified else { return }
//
//        if !isEmailVerified {
//            self.sendVerificationEmail()
//        }
//    }
    private func sendVerificationEmail() {
//        guard let viewModel = viewModel, let currentUser = viewModel.currentUser else { return }
//
//        if !currentUser.isEmailVerified {
//            currentUser.sendEmailVerification { error in
//                if let error = error {
//                    self.presentBaseErrorAlert(message: "\(error.localizedDescription)")
//                } else {
//                    self.presentAlertController(withMessage: "Email verification link has been sent to your email account")
//                }
//            }
//        } else {
//            self.presentBaseErrorAlert(message: "Operation could not be completed.\nPlease check if your email is correct.")
//        }
    }
    
    //                guard let currentUser = authResult?.user,
    //                      let isEmailVerified = authResult?.user.isEmailVerified
    //                else { return }
    //
    //                if !isEmailVerified {
    //                    currentUser.sendEmailVerification { error in
    //                        if let error = error {
    //                            self.presentBaseErrorAlert(message: "\(error.localizedDescription)")
    //                        } else {
    //                            self.presentAlertController(withMessage: "Email verification link has been sent to your email account")
    //                        }
    //                    }
    //
    //
    //                } else {
    //                    self.presentBaseErrorAlert(message: "Operation could not be completed.\nPlease check if your email is correct.")
    //                }
}

// MARK: - UITextFieldDelegate
extension LoginScene: UITextFieldDelegate {
    
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    }

    if textField == passwordTextField {
      textField.resignFirstResponder()
    }
    
    return true
  }
}

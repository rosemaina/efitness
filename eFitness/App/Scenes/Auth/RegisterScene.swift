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
        configureObservables()
    }
    
    // MARK: - Instance Methods
    @IBAction func presentLoginScene() {
        self.presentLogin()
    }
    
    // MARK: - Private Methods
    func configureViews() {
        viewModel = RegisterViewModel()

        signUpButton.addCornerRadiusAndShadow()
        emailTextField.keyboardType = .emailAddress
        emailTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
        usernameTextField.addDoneButtonOnKeyboard()
        
        hideKeyboard()
    }
    
    func presentLogin() {
        let scene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginScene") as! LoginScene
        scene.modalPresentationStyle = .fullScreen
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

// MARK: - RXswift Setup
extension RegisterScene {
    func configureObservables() {
        guard let viewModel = viewModel else { return }
        
        emailTextField
            .rx
            .controlEvent(.editingChanged).asDriver()
            .do(onNext: { [weak self] _ in
                self?.viewModel?.email.accept(self?.emailTextField.text?.removingSpaces ?? "")
            }).drive()
            .disposed(by: viewModel.disposeBag)
        
        passwordTextField
            .rx
            .controlEvent(.editingChanged).asDriver()
            .do(onNext: { [weak self] _ in
                self?.viewModel?.password.accept(self?.passwordTextField.text?.removingSpaces ?? "")
            }).drive()
            .disposed(by: viewModel.disposeBag)
        
        usernameTextField
            .rx
            .controlEvent(.editingChanged).asDriver()
            .do(onNext: { [weak self] _ in
                self?.viewModel?.username.accept(self?.usernameTextField.text?.removingSpaces ?? "")
            }).drive()
            .disposed(by: viewModel.disposeBag)
        
        viewModel
            .enableRegisterAction
            .asDriver()
            .do(onNext: {value in
                let color = value ? Colors.darkGreen : Colors.inactiveGray
                self.signUpButton.backgroundColor = color
            })
            .drive()
            .disposed(by: viewModel.disposeBag)
        
        signUpButton
            .rx
            .tap
            .bind{[weak self] _ in
                guard let self = self else { return }
                guard let viewModel = self.viewModel else { return }
                
                viewModel.validateEmail()
                viewModel.validatePassword()
                viewModel.validateUsername()
                
                let passwordMsg = viewModel.passwordAlertMessage
                let emailMsg = viewModel.emailAlertMessage
                let usernameMsg = viewModel.usernameAlertMessage
                
                if passwordMsg.isEmpty && emailMsg.isEmpty && usernameMsg.isEmpty {
                    self.registerUser(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", username: self.usernameTextField.text ?? "")
                } else {
                    self.presentActionSheet(message: "1. \(emailMsg) \n2. \(passwordMsg) \n3. \(usernameMsg)")
                }
            }.disposed(by: viewModel.disposeBag)
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
                
                guard let uid = authResult?.user.uid else { return }
                
                // Save Data for Authenticated User
                let userID = self.reference.child("users").child(uid)
                let values = ["username": username, "email": email]
                userID.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        self.presentErrorAlert(message: "\(error.localizedDescription)")
                    }
                })
                
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

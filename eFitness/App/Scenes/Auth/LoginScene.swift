//
//  LoginScene.swift
//  eFitness
//
//  Created by Rose Maina on 20/10/2021.
//

import Firebase
import UIKit
import RxSwift
import RxCocoa

class LoginScene: UIViewController {
    
    // MARK: - Instance Properties
    var viewModel: LoginViewModel?
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.addStateDidCHangeListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    // MARK: - Public Instance Methods
    @IBAction func presentRegistrationScene() {
        self.presentRegistration()
    }
    
    @IBAction func handleUserLogin() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        loginUser(email: email, password: password)
    }
    
    // MARK: - Private Methods
    
    func clearTextfields() {
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
    func configureViews() {
        viewModel = LoginViewModel()

        loginButton.isEnabled = false
        loginButton.addCornerRadiusAndShadow()
        emailTextField.keyboardType = .emailAddress
        emailTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
        
        hideKeyboard()
    }
    
    func presentRegistration() {
        let scene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterScene") as! RegisterScene
        self.present(scene, animated: true, completion: nil)
    }
    
    func presentHomeTabBar() {
        let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
        // This is to get the SceneDelegate object from your view controller and call change root vc
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(tabVC)
    }
    
    func presentResendVerificationAlert(_ authResult: AuthDataResult?) {
        let message = "Your email has not been verified. Please verify your email to contiue."
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Resend Link", style: .default) { _ in
            self.sendVerificationEmail(authResult)
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - RXswift Setup
extension LoginScene {
    func configureObservables() {
        guard let viewModel = viewModel else { return }
        
        emailTextField.rx.controlEvent([.editingChanged, .editingDidEnd]).asObservable().subscribe({ _ in
            viewModel.isEmailValid.onNext(viewModel.validateEmail(email: self.emailTextField.text))
        }).disposed(by: viewModel.disposeBag)
        
        passwordTextField.rx.controlEvent([.editingChanged, .editingDidEnd]).asObservable().subscribe({ _ in
            viewModel.isPasswordValid.onNext(viewModel.validatePassword(password: self.passwordTextField.text))
        }).disposed(by: viewModel.disposeBag)
        
        let email = viewModel.isEmailValid.asObservable()
        let password = viewModel.isPasswordValid.asObservable()
        
        Observable.combineLatest(email, password) { [unowned self] emailStatus, passwordStatus in
            let buttonEnabled = emailStatus && passwordStatus
            self.loginButton.backgroundColor = buttonEnabled ? Colors.darkGreen : Colors.inactiveGray
            self.loginButton.isEnabled = buttonEnabled ? true : false
        }.subscribe().disposed(by: viewModel.disposeBag)
        
        viewModel.showInvalidEmailAlert.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] show in
            guard let self = self else {return}
            if show {
                self.presentHomeTabBar()
            }
        }).disposed(by: viewModel.disposeBag)
            
        // Alert Messages
//        viewModel.showEmptyFieldsAlert.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] show in
//            guard let self = self else {return}
//            if show {
//                self.presentCustomAlert(title: "Empty Fields", message: "All fields are required to contiue.")
//            }
//        }).disposed(by: viewModel.disposeBag)
//
//        viewModel.showInvalidEmailAlert.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] show in
//            guard let self = self else {return}
//            if show {
//                self.presentCustomAlert(title: "Invalid Email", message: "Please enter a valid email address")
//            }
//        }).disposed(by: viewModel.disposeBag)
//
//        viewModel.showInvalidPasswordAlert.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] show in
//            guard let self = self else {return}
//            if show {
//                self.presentCustomAlert(title: "Invalid Password", message: "Password should contain 8-10 characters, uppercase letter, lowercase letter, number and special character.")
//            }
//        }).disposed(by: viewModel.disposeBag)
    }
}

// MARK: - Firebase Methods
extension LoginScene {
    
    private func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error as NSError?, authResult == nil {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed, .userDisabled:
                    self.presentErrorAlert(message: "Operation failed. Please contact system administrator.")
                case .invalidEmail, .wrongPassword:
                    self.presentErrorAlert(message: "Invalid email/ password. Please try again.")
                default:
                    self.presentErrorAlert(message: "\(error.localizedDescription)")
                }
            } else {
                let isEmailValid = userDefaults.bool(forKey: "isEmailVerified")
                
                if !isEmailValid {
                    self.presentResendVerificationAlert(authResult)
                } else {
                    UserDefaults.standard.setValue(true, forKey: "userIsLoggedIn")
                    UserDefaults.standard.set(authResult?.user.uid, forKey: "USER_KEY_UID")
                    UserDefaults.standard.synchronize()
                    
                    self.presentHomeTabBar()
                    self.clearTextfields()
                }
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
                }
            }
        } else {
            self.presentErrorAlert(message: "User does not exist or is already verified.")
        }
    }
}

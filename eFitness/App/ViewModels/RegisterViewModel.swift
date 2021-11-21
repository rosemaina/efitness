//
//  RegisterViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import RxCocoa
import RxSwift

class RegisterViewModel: BaseViewModel {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var emailAlertMessage = ""
    var passwordAlertMessage = ""
    var usernameAlertMessage = ""
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var username = BehaviorRelay<String>(value: "")
    
    var showTabBarScene = PublishRelay<Bool>()
    var enableRegisterAction = BehaviorRelay<Bool>(value: false)
    
    private var onscreenEmail = ""
    private var onscreenPassword = ""
    private var onscreenUsername = ""
    
    lazy var validator: Validator = {
        return TextFieldValidator()
    }()
    
    // MARK: - Initializer
    override init() {
        super.init()
        
        self.validateInput()
    }
    
    // MARK: - Public Methods
    private func validateInput() {
        Observable
            .combineLatest(email.asObservable(),
                           password.asObservable(),
                           username.asObservable())
            { [weak self] email, password, username in
                guard let self = self else  { return }
                self.onscreenEmail = email
                self.onscreenPassword = password
                self.onscreenUsername = username
                
                let isFieldsValid = !email.isEmpty && !password.isEmpty && !username.isEmpty
                self.enableRegisterAction.accept(isFieldsValid)
            }
            .observeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func validateEmail() {
        emailAlertMessage = ""
        var message = ""
        
        let isEmailVaid = validator.isEmailValid(onscreenEmail)
        
        if !isEmailVaid {
            message = "Please enter a valid email address."
        }
        
        emailAlertMessage = message
    }
    
    func validatePassword() {
        passwordAlertMessage = ""
        var message = ""
        
        let isPasswordValid = self.validator.isPasswordValid(onscreenPassword)
    
        if !isPasswordValid {
            message = "Password should contain 8-10 characters, uppercase letter, lowercase letter, number and special character."
        }
        
        passwordAlertMessage = message
    }
    
    func validateUsername() {
        usernameAlertMessage = ""
        var message = ""
    
        if onscreenUsername.count < 7 {
            message = "Username should have more than 6 characters"
        }
        
        usernameAlertMessage = message
    }
    
//    func sendVerificationEmail() {
//        guard let currentUser = self.currentUser else { return }
//
//        if !currentUser.isEmailVerified {
//            currentUser.sendEmailVerification { error in
//                if let error = error {
//                    self.showErrorAlert.accept("\(error.localizedDescription)")
//                } else {
//                    self.showSuccessAlert.accept("Email verification link has been sent to your email account")
//                }
//            }
//        } else {
//            self.showFailureAlert.accept("Operation could not be completed.\nPlease check if your email is correct.")
//        }
//    }
}

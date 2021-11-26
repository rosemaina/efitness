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
            .combineLatest(email.asObservable(), password.asObservable(), username.asObservable()) { [weak self] email, password, username in
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
            message = "Password should be 8 or more. Include alphanumerics and specual characters for a strong password."
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
}

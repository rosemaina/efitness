//
//  LoginViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase
import RxCocoa
import RxSwift

class LoginViewModel {

    // MARK: - Properties
    let disposeBag = DisposeBag()
    var handle: AuthStateDidChangeListenerHandle?
    
    var emailAlertMessage = ""
    var passwordAlertMessage = ""
    var showTabBarScene = PublishRelay<Bool>()
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var enableLoginAction = BehaviorRelay<Bool>(value: false)
    
    private var onscreenPassword = ""
    private var onscreenEmail = ""
    
    lazy var validator: Validator = {
        return TextFieldValidator()
    }()
    
    // MARK: - Initializer
    init() {
        self.validateInput()
    }
    
    // MARK: - Public Methods
    private func validateInput() {
        Observable
            .combineLatest(email.asObservable(),
                           password.asObservable())
            { [weak self] email, password in
                guard let self = self else  { return }
                self.onscreenEmail = email
                self.onscreenPassword = password
                
                let isFieldsValid = !email.isEmpty && !password.isEmpty
                self.enableLoginAction.accept(isFieldsValid)
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
    
    // Handle user login state
    func addStateDidCHangeListener() {
        handle = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
            guard let self = self else { return }
            if user != nil {
                self.showTabBarScene.accept(true)
            }
        })
    }
}

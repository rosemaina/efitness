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
    
    lazy var validator: Validator = {
        return TextFieldValidator()
    }()
    
    var isEmailValid = BehaviorSubject(value: false)
    var isPasswordValid = BehaviorSubject(value: false)
    
    var showEmptyFieldsAlert = PublishRelay<Bool>()
    var showInvalidEmailAlert = PublishRelay<Bool>()
    var showInvalidPasswordAlert = PublishRelay<Bool>()
    var showTabBarScene = PublishRelay<Bool>()
    
    // MARK: - Public Methods
    
    func validateEmail(email: String?) -> Bool {
        guard let email = email else {
            isEmailValid.onNext(false)
            return false
        }
        
        let validEmail = self.validator.isEmailValid(email)
        
        if !validEmail {
            isEmailValid.onNext(false)
            self.showInvalidEmailAlert.accept(true)
            return false
        }
        
        if email.isEmpty {
            self.showEmptyFieldsAlert.accept(true)
        }
        
        isEmailValid.onNext(true)
        return true
    }
    
    func validatePassword(password: String?) -> Bool {
        guard let password = password else {
            isPasswordValid.onNext(false)
            return false
        }
        
        let validPassword = self.validator.isPasswordValid(password)
        
        if !validPassword {
            isPasswordValid.onNext(false)
            self.showInvalidPasswordAlert.accept(true)
            return false
        }
        
        if password.isEmpty {
            self.showEmptyFieldsAlert.accept(true)
        }
        
        isPasswordValid.onNext(true)
        return true
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

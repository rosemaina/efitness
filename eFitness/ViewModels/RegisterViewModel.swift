//
//  RegisterViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import RxCocoa
import RxSwift

class RegisterViewModel: BaseViewModel {
    
    var showErrorAlert = PublishRelay<(String?)>()
    var showSuccessAlert = PublishRelay<(String?)>()
    var showFailureAlert = PublishRelay<(String?)>()

    func sendVerificationEmail() {
        guard let currentUser = self.currentUser else { return }
        
        if !currentUser.isEmailVerified {
            currentUser.sendEmailVerification { error in
                if let error = error {
                    self.showErrorAlert.accept("\(error.localizedDescription)")
                } else {
                    self.showSuccessAlert.accept("Email verification link has been sent to your email account")
                }
            }
        } else {
            self.showFailureAlert.accept("Operation could not be completed.\nPlease check if your email is correct.")
        }
    }
}

//
//  HomeViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 26/11/2021.
//

import RxCocoa
import RxSwift
import Firebase

class HomeViewModel: BaseViewModel {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var username = BehaviorRelay(value: "")
    var email = BehaviorRelay(value: "")
    var salutationText = BehaviorRelay(value: "")
    
    override init() {
        super.init()
    }
    
    func setupSalutationText() {
        guard let userID = Auth.auth().currentUser?.uid  else { return }
        self.roofReference.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                guard let response = snapshot.value as? [String: String] else { return }
                self.salutationText.accept("Hello, \(response["username"] ?? "there" )!")
            }
        })
    }
}

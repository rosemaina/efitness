//
//  HomeViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import RxCocoa
import RxSwift
import Firebase

//struct UserDetails {
//    var name, username, email, age, height, weight: String
//}

class HomeViewModel: BaseViewModel {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var age = BehaviorRelay(value: "")
    var height = BehaviorRelay(value: "")
    var weight = BehaviorRelay(value: "")
    var name = BehaviorRelay(value: "")
    var username = BehaviorRelay(value: "")
    var email = BehaviorRelay(value: "")
    var salutationText = BehaviorRelay(value: "")
    
    lazy var manageActions: [AccountActions] = [.editProfile, .changePassword, .aboutApp, .logout, .deleteAccount]
    
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

// MARK: - Validations
extension HomeViewModel {
    
}

// MARK: Account User Actions
extension HomeViewModel {
    
    enum AccountActions {
        case editProfile
        case changePassword
        case aboutApp
        case logout
        case deleteAccount
        
        var info: (image: UIImage?, text: String) {
            switch self {
            case .editProfile:
                return (UIImage(named: "puk"), "Edit Profile")
            case .changePassword:
                return (UIImage(named: "sambaza"), "Change password")
            case .aboutApp:
                return (UIImage(named: "bonga_points"), "About eFitness")
            case .logout:
                return (UIImage(named: "myusage"), "Logout")
            case .deleteAccount:
                return (UIImage(named: "subscription_icon"), "Delete Account")
            }
        }
    }
}

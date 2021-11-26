//
//  AccountViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import RxCocoa
import RxSwift
import Firebase

class AccountViewModel: BaseViewModel {
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
}

// MARK: - Validations
extension HomeViewModel {
    
}

// MARK: Account User Actions
extension AccountViewModel {
    
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
                return (UIImage(named: "sambaza"), "Reset Password")
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

//
//  ProfileScene.swift
//  eFitness
//
//  Created by Rose Maina on 20/11/2021.
//

import Firebase
import RxSwift
import UIKit

class ProfileScene: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var updateProfileButton: UIButton!
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var heightTextfield: UITextField!
    @IBOutlet weak var weightTextfield: UITextField!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var salutationLabel: UILabel!
    
    // MARK: - Ovveride Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureObservables()
    }
    
    // MARK: - Public Methods
    
    @IBAction func backBtnTapped() {
        presentAccountScene()
    }
    
    @IBAction func updateUserProfile() {
        updateProfileData()
    }
    
    func configureViews() {
        viewModel = HomeViewModel()
        
        updateProfileButton.addCornerRadiusAndShadow()
        
        ageTextfield.keyboardType = .numberPad
        heightTextfield.keyboardType = .numberPad
        weightTextfield.keyboardType = .numberPad
        
        nameTextfield.addDoneButtonOnKeyboard()
        ageTextfield.addDoneButtonOnKeyboard()
        heightTextfield.addDoneButtonOnKeyboard()
        weightTextfield.addDoneButtonOnKeyboard()
        
        hideKeyboard()
        setupSalutationText()
    }
    
    func presentAccountScene() {
        let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(tabVC)
    }
    
    func showSuccessAlert() {
        let message = "You have successfully updated your profile."
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            self.presentAccountScene()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupSalutationText() {
        self.roofReference.child("users").child(userID).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if snapshot.exists() {
                guard let self = self, let response = snapshot.value as? [String: String] else { return }
                self.viewModel?.salutationText.accept("Hello, \(response["username"] ?? "there" )!")
                self.viewModel?.email.accept(response["email"] ?? "")
                self.salutationLabel.text = self.viewModel?.salutationText.value
            }
        })
    }
    
//    func updateUserEmail(with email: String) {
//        guard let currentUser = Auth.auth().currentUser else { return }
//
//        if !email.isEmpty {
//            currentUser.updateEmail(to: email, completion: { [weak self] error in
//                guard let self = self else { return }
//
//                if let error = error {
//                    self.presentBaseErrorAlert(message: error.localizedDescription)
//                } else {
//                    let reference = self.roofReference.child("users").child(self.userID).child("email")
//                    reference.setValue(email)
//                }
//            })
//        }
//    }
    
    func updateProfileData() {
        guard  let viewModel = viewModel else { return }
        let rootRef = roofReference.child("users").child(userID)
        
        let values = ["name": viewModel.name.value,
                      "age": viewModel.age.value,
                      "heightInCm": viewModel.height.value,
                      "weightInKg": viewModel.weight.value]
                
        rootRef.updateChildValues(values) { error, _ in
            if let error = error {
                self.presentBaseErrorAlert(message: error.localizedDescription)
            } else {
                self.showSuccessAlert()
            }
        }
    }
}

// MARK: - RxSwift Setup
extension ProfileScene {
    func configureObservables() {
        guard let viewModel = viewModel else { return }
        
        nameTextfield.rx.text.orEmpty.subscribe(onNext: { value in
            viewModel.name.accept(value)
        }).disposed(by: viewModel.disposeBag)
        
        ageTextfield.rx.text.orEmpty.subscribe(onNext: { value in
            viewModel.age.accept(value)
        }).disposed(by: viewModel.disposeBag)
        
        heightTextfield.rx.text.orEmpty.subscribe(onNext: { value in
            viewModel.height.accept(value)
        }).disposed(by: viewModel.disposeBag)
        
        weightTextfield.rx.text.orEmpty.subscribe(onNext: { value in
            viewModel.weight.accept(value)
        }).disposed(by: viewModel.disposeBag)
        
        
        let nameObservable = nameTextfield.rx.text.asObservable()
        let ageObservable = ageTextfield.rx.text.asObservable()
        let heightObservable = heightTextfield.rx.text.asObservable()
        let weightObservable = weightTextfield.rx.text.asObservable()
        
        Observable.combineLatest(nameObservable, ageObservable, heightObservable, weightObservable) { [unowned self] name, age, height, weight in
            let buttonEnabled = name != nil || age != nil || height != nil || weight != nil
            
            self.updateProfileButton.backgroundColor = buttonEnabled ? Colors.darkGreen : Colors.inactiveGray
            self.updateProfileButton.isEnabled = buttonEnabled ? true : false
        }.subscribe().disposed(by: viewModel.disposeBag)
    }
}

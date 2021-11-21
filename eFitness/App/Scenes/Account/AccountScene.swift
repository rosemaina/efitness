//
//  AccountScene.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase
import RxSwift
import UIKit

class AccountScene: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var salutationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var manageTable: UITableView!
    
    // MARK: - Ovveride Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Instance Methods
    func configureViews()  {
        viewModel = HomeViewModel()
        setupView()
    }

    func setupView() {
        ageView.addCornerRadiusAndShadow()
        heightView.addCornerRadiusAndShadow()
        weightView.addCornerRadiusAndShadow()
        
        setupSalutationText()
        setupTable()
    }
    
    func presentAboutApp() {
        print("Presenting About App")
    }
    
    func presentChangePassword() {
        print("Presenting Change Password")
    }
    
    func presentEditProfile() {
        let scene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileScene") as! ProfileScene
        scene.modalPresentationStyle = .fullScreen
        self.present(scene, animated: true, completion: nil)
    }
    
    func presentRegistrationScene() {
        let scene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterScene") as! RegisterScene
        scene.modalPresentationStyle = .fullScreen
        self.present(scene, animated: true, completion: nil)
    }
    
    func setupTable() {
        manageTable.delegate = self
        manageTable.dataSource = self
        manageTable.separatorStyle = .none
        manageTable.tableFooterView = UIView()
        manageTable.backgroundColor = Colors.backgroundGreen
        manageTable.register(ManageAccountCell.self, forCellReuseIdentifier: ManageAccountCell.identifier)
    }
    
    func confirmLogoutAlert() {
        let message = "Are you sure you want to logout?"
        let alertController = UIAlertController(title: "Logout", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            do {
                try Auth.auth().signOut()
                let scene = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginScene")
                scene.modalPresentationStyle = .fullScreen
                self.present(scene, animated: true, completion: nil)
            } catch let signOutError as NSError {
                self.presentErrorAlert(message: signOutError as! String)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAccountConfirmAlert() {
        let message = "You are about to delete your account. Do you wish to continue?"
        let alertController = UIAlertController(title: "Delete Account", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let continueAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.deleteAccountAlert()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAccountAlert() {
        let message = "Once you delete your account, there's no going back. Make sure you want to do it."
        let alertController = UIAlertController(title: "Whoa, there!", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes, Delete It", style: .destructive) { [weak self] _ in
            self?.deleteUserAccount()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAccountSuccessAlert() {
        let message = "Your account has been deleted successfully."
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.presentRegistrationScene()
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupSalutationText() {
        guard let userID = Auth.auth().currentUser?.uid  else { return }
        self.roofReference.child("users").child(userID).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if snapshot.exists() {
                guard let self = self, let response = snapshot.value as? [String: String] else { return }
                self.viewModel?.salutationText.accept("Hello, \(response["username"] ?? "there" )!")
                self.viewModel?.email.accept(response["email"] ?? "--@--.com")
                self.viewModel?.name.accept(response["name"] ?? "---")
                self.viewModel?.age.accept(response["age"] ?? "--")
                self.viewModel?.height.accept(response["heightInCm"] ?? "--")
                self.viewModel?.weight.accept(response["weightInKg"] ?? "--")
                
                self.salutationLabel.text = self.viewModel?.salutationText.value
                self.nameLabel.text = self.viewModel?.name.value
                self.emailLabel.text = self.viewModel?.email.value
                self.ageLabel.text = self.viewModel?.age.value
                self.heightLabel.text = self.viewModel?.height.value
                self.weightLabel.text = self.viewModel?.weight.value
            }
        })
    }
}

// MARK: - TableView Methods
extension AccountScene: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.manageActions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ManageAccountCell.identifier, for: indexPath) as? ManageAccountCell,
            let viewModel = viewModel
        else { return UITableViewCell() }
        
        cell.titleLabel.text = viewModel.manageActions[indexPath.section].info.text        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        switch viewModel.manageActions[indexPath.section] {
        case .editProfile:
            self.presentEditProfile()
        case .changePassword:
            self.presentChangePassword()
        case .aboutApp:
            self.presentAboutApp()
        case .logout:
            self.confirmLogoutAlert()
        case .deleteAccount:
            self.deleteAccountConfirmAlert()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Firebase Methods
extension AccountScene {
    func deleteUserAccount() {
        Auth.auth().currentUser?.delete(completion: { (error) in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    self.presentErrorAlert(message: "Operation Not Allowed. Ensure email and password is correct.")
                case .requiresRecentLogin:
                    print("Reauthenticate user")
                default:
                    self.presentErrorAlert(message: "\(error.localizedDescription)")
                }
            } else {
                self.deleteAccountSuccessAlert()
            }
        })
    }
}

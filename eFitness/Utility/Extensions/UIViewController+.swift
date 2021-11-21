//
//  UIViewController+.swift
//  eFitness
//
//  Created by Rose Maina on 20/10/2021.
//

import UIKit
import Firebase

public enum AppStoryboard: String {

    case Main
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type, identifier: String? = nil) -> T {
        let storyboardId = identifier ?? (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardId) as? T else {
            fatalError("Viewcontroller with ID \(storyboardId), not found in \(self.rawValue) Storyboard")
        }
        
        return scene
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    public static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard, withIdentifier identifier: String? = nil) -> Self {
        return appStoryboard.viewController(viewControllerClass: self, identifier: identifier)
    }
}

extension UIViewController {
    var roofReference: DatabaseReference {
        return  Database.database().reference()
    }
    
    var userID: String {
        guard let userId = Auth.auth().currentUser?.uid  else { return "" }
        return  userId
    }
}

// MARK: - Configure Alerts
extension UIViewController {
    func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentSuccessAlert(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentBaseErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentCustomAlert(title: String, message: String) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentActionSheet(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Dimiss Keyboard
extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

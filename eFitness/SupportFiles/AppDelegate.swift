//
//  AppDelegate.swift
//  eFitness
//
//  Created by Rose Maina on 20/10/2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var authListener: AuthStateDidChangeListenerHandle?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
//
//        guard var listener = authListener else { return false }
//        listener = Auth.auth().addStateDidChangeListener({ auth, user in
//            Auth.auth().removeStateDidChangeListener(listener)
//
//            if let user = user {
//                DispatchQueue.main.async {
//                    self.presentHome(withUser: user)
//                }
//            } else {
//                DispatchQueue.main.async {
                    self.presentOnboarding()
//                }
//            }
//        })
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url)
//    }
    
    @discardableResult
    private func presentHome(withUser currentUser: User) -> Bool {
        let client = EfitnessClient(user: currentUser)
        
        let homeVC = HomeScene()
        homeVC.viewModel = HomeViewModel(client: client)
                
        let navController = UINavigationController.init(rootViewController: homeVC)
        navController.navigationBar.isHidden = true
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    @discardableResult
    private func presentOnboarding() -> Bool {
        let navController = UINavigationController.init(rootViewController: OnboardingScene1())
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

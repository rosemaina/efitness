//
//  HomeScene.swift
//  eFitness
//
//  Created by Rose Maina on 26/11/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HomeScene: UIViewController {
    // MARK: - Instance Properties
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var salutationLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        configureViews()
    }

    // MARK: - Public Instance Methods
    @IBAction func presentCameraScene() {
        let scene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraScene") as! CameraScene
        scene.modalPresentationStyle = .fullScreen
        self.present(scene, animated: true, completion: nil)
    }
    
    func configureViews() {
        cameraButton.addCornerRadiusAndShadow()
        setupSalutationText()
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
}

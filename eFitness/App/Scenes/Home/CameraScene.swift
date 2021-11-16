//
//  CameraScene.swift
//  eFitness
//
//  Created by Rose Maina on 28/10/2021.
//

import UIKit

class CameraScene: UIViewController {
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    // MARK: - Private Methods
    private func initialSetup() {
        view.backgroundColor = .white
        title = "Capture Photo"
        
        let takePhotoButton = UIButton(type: .system)
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.setTitle("Take Photo", for: .normal)
        takePhotoButton.setTitleColor(.white, for: .normal)
        takePhotoButton.backgroundColor = UIColor.darkGray
        takePhotoButton.layer.cornerRadius = 5
        takePhotoButton.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        view.addSubview(takePhotoButton)
        
        takePhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takePhotoButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        takePhotoButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc private func handleTakePhoto() {
        let controller = CustomCameraScene()
        self.present(controller, animated: true, completion: nil)
    }
}

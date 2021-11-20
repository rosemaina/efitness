//
//  AccountScene.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase
import UIKit

class AccountScene: UIViewController {
    
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews()  {
        viewModel = HomeViewModel()
    }
    
    @IBAction func editProfile() {
        let scene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileScene") as! ProfileScene
        scene.modalPresentationStyle = .fullScreen
        self.present(scene, animated: true, completion: nil)
    }
}

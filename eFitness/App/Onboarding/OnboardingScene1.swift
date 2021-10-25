//
//  OnboardingScene1.swift
//  eFitness
//
//  Created by Rose Maina on 20/10/2021.
//

import UIKit

class OnboardingScene1: UIViewController {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func skippButtonTapped() {
        print("presentRegisterViewController")
    }
    
    @IBAction func nextButtonTapped() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "OnboardingScene2") as! OnboardingScene2
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
}

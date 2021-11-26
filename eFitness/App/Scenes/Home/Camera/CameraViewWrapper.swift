//
//  CameraViewWrapper.swift
//  eFitness
//
//  Created by Rose Maina on 27/11/2021.
//

import AVFoundation
import SwiftUI
import Vision

struct CameraViewWrapper: UIViewControllerRepresentable {
    
    var poseEstimator: PoseEstimator
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let cvc = CameraScene()
        cvc.delegate = poseEstimator
        return cvc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

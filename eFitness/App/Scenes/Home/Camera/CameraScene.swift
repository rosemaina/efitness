//
//  CameraScene.swift
//  eFitness
//
//  Created by Rose Maina on 28/10/2021.
//

import AVFoundation
import SwiftUI
import UIKit
import Vision

final class CameraScene: UIViewController {
    
    // MARK: - Instance Properties    
    var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    var cameraSession: AVCaptureSession?
    
    let cameraQueue = DispatchQueue(label: "CameraFeedOutput", qos: .userInteractive)
    let childView = UIHostingController(rootView: ContentView())
    
    // MARK: - Methods
    override func loadView() {
        view = CameraView()
    }
    
    private var cameraView: CameraView { view as! CameraView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUiViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            if cameraSession == nil {
                try prepareAVSession()
                cameraView.previewLayer.session = cameraSession
                cameraView.previewLayer.videoGravity = .resizeAspectFill
            }
            
            cameraSession?.startRunning()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    func setupSwiftUiViews() {
        addChild(childView)
//        view.addSubview(childView.view)
        
//        childView.didMove(toParent: self)
//        childView.view.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
////            childView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            childView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            childView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            childView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            childView.view.heightAnchor.constraint(equalToConstant: 100)
//        ])
    }
    
    func prepareAVSession() throws {
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let deviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(deviceInput)
        else { return }
        
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.setSampleBufferDelegate(delegate, queue: cameraQueue)
        } else { return }
        
        session.commitConfiguration()
        cameraSession = session
    }
}

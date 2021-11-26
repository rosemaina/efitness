////
////  CameraScene.swift
////  eFitness
////
////  Created by Rose Maina on 28/10/2021.
////
//
//import AVFoundation
//import UIKit
//import Vision
//
//class CameraScene: UIViewController {
//
//    // create a computed property called to access the root view as CameraPreview.
//    // You can safely force cast here because you recently assigned an instance of CameraPreview to view in step one
//    private var cameraView: CameraPreview { view as! CameraPreview }
//
//    // Add a property for the closure to run when the framework detects points
//    var pointsProcessorHandler: (([CGPoint]) -> Void)?
//
//    private var overlayPoints: [CGPoint] = []
//    private var cameraFeedSession: AVCaptureSession?
//
//    // Add a new property for the dispatch queue on which Vision will process the camera samples
//    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedOutput", qos: .userInteractive)
//
//    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
//        // Create a request for detecting human hands
//        let request = VNDetectHumanHandPoseRequest()
//
//        // Set the maximum number of hands to detect
//        request.maximumHandCount = 2
//        return request
//    }()
//
//
//    // MARK: - View LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    // Override loadView to make the view controller use CameraPreview as its root view
//    override func loadView() {
//        view = CameraPreview()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        do {
//            // check to see if you’ve already initialized cameraFeedSession
//            if cameraFeedSession == nil {
//                // call setupAVSession(), which is empty for now
//                try setupAVSession()
//
//                // set the session into the session of the previewLayer of cameraView and set the resize mode of the video
//                cameraView.previewLayer.session = cameraFeedSession
//                cameraView.previewLayer.videoGravity = .resizeAspectFill
//            }
//
//            // start running the session. This makes the camera feed visible
//            cameraFeedSession?.startRunning()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    // turn off camera to [reserve battery
//    override func viewWillDisappear(_ animated: Bool) {
//        cameraFeedSession?.stopRunning()
//        super.viewWillDisappear(animated)
//    }
//
//    func processPoints(_ fingerTips: [CGPoint]) {
//        // Convert from AVFoundation relative coordinates to UIKit coordinates so you can draw them on screen
//        let convertedPoints = fingerTips.map {
//            cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
//        }
//
//        // call the closure with the converted points
//        pointsProcessorHandler?(convertedPoints)
//    }
//
//
//    // prepare the camera
//    func setupAVSession() throws {
//
//        // Check if the device has a front-facing camera
//        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
//        else { throw AppError.captureSessionSetup(reason: "Could not find a front facing camera.") }
//
//        // check if you can use the camera to create a capture device input
//        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice)
//        else { throw AppError.captureSessionSetup(reason: "Could not create video device input.") }
//
//        // Create a capture session and start configuring it using the high quality preset
//        let session = AVCaptureSession()
//        session.beginConfiguration()
//        session.sessionPreset = AVCaptureSession.Preset.high
//
//        // check if the session can integrate the capture device input
//        guard session.canAddInput(deviceInput)
//        else { throw AppError.captureSessionSetup(reason: "Could not add video device input to the session") }
//        // if true, add input created
//        session.addInput(deviceInput)
//
//        // create a data output and add it to the session
//        // The data output will take samples of images from the camera feed and
//        // provide them in a delegate on a defined dispatch queue
//        let dataOutput = AVCaptureVideoDataOutput()
//
//        if session.canAddOutput(dataOutput) {
//            session.addOutput(dataOutput)
//            dataOutput.alwaysDiscardsLateVideoFrames = true
//            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
//        } else {
//            throw AppError.captureSessionSetup(reason: "Could not add video data output to the session")
//        }
//
//        // finish configuring the session and assign it to cameraFeedSession
//        session.commitConfiguration()
//        cameraFeedSession = session
//    }
//}
//
//// MARK: - AVCapture Methods
//extension CameraScene: AVCaptureVideoDataOutputSampleBufferDelegate {
//
//    // pass the sample buffer you get as an input parameter to perform the request on a single image
//    // get a sample out of the capture stream and start the detection process
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//
//        // store the detected fingertips
//        var fingerTips: [CGPoint] = []
//
//        //This will send your finger tips to be processed on the main queue once the method is finished
//        defer {
//            DispatchQueue.main.sync {
//                self.processPoints(fingerTips)
//            }
//        }
//
//        // called whenever a sample is available
//        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
//
//        do {
//            //  perform the request
//            try handler.perform([handPoseRequest])
//
//            // get the detection result
//            guard
//                let results = handPoseRequest.results?.prefix(2), !results.isEmpty
//            else { return }
//
//            var recognizedPoints: [VNRecognizedPoint] = []
//
//            try results.forEach { observation in
//                // Get the points for all fingers
//                let fingers = try observation.recognizedPoints(.all)
//
//                // Look for tip points
//                if let thumbTipPoint = fingers[.thumbTip] {
//                    recognizedPoints.append(thumbTipPoint)
//                }
//
//                if let indexTipPoint = fingers[.indexTip] {
//                    recognizedPoints.append(indexTipPoint)
//                }
//
//                if let middleTipPoint = fingers[.middleTip] {
//                    recognizedPoints.append(middleTipPoint)
//                }
//
//                if let ringTipPoint = fingers[.ringTip] {
//                    recognizedPoints.append(ringTipPoint)
//                }
//
//                if let littleTipPoint = fingers[.littleTip] {
//                    recognizedPoints.append(littleTipPoint)
//                }
//            }
//
//            // Each VNRecognizedPoint has a confidence. You only want observations with high confidence levels.
//            fingerTips = recognizedPoints.filter {
//                // Ignore low confidence points.
//                $0.confidence > 0.9
//            }.map {
//                // Vision algorithms use a coordinate system with lower left origin and return normalized values relative to the pixel dimension of the input image. AVFoundation coordinates have an upper-left origin, so you convert the y-coordinate.
//                CGPoint(x: $0.location.x, y: 1 - $0.location.y)
//            }
//
//        } catch {
//            // handle errors here
//            print("Unable to perform the request: \(error).")
//
//            cameraFeedSession?.stopRunning()
//        }
//    }
//}
//
//////
//////  CustomCameraScene.swift
//////  eFitness
//////
//////  Created by Rose Maina on 08/11/2021.
//////
////
////import UIKit
////import AVFoundation
////
////class CustomCameraScene: UIViewController, AVCapturePhotoCaptureDelegate {
////
////    // MARK: - Variables
////    lazy private var backButton: UIButton = {
////        let button = UIButton(type: .system)
////        button.setImage(UIImage(systemName: "xmark"), for: .normal)
////        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
////        button.tintColor = .white
////        return button
////    }()
////
////    lazy private var takePhotoButton: UIButton = {
////        let button = UIButton(type: .system)
////        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
////        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
////        return button
////    }()
////
////    private let photoOutput = AVCapturePhotoOutput()
////
////
////    // MARK: - View LifeCycle
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        openCamera()
////    }
////
////
////    // MARK: - Private Methods
////    private func setupUI() {
////
////        view.addSubviews(backButton, takePhotoButton)
////
////        takePhotoButton.makeConstraints(top: nil, left: nil, right: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 15, width: 80, height: 80)
////        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
////
////        backButton.makeConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: nil, right: view.rightAnchor, bottom: nil, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 50, height: 50)
////    }
////
////    private func openCamera() {
////        switch AVCaptureDevice.authorizationStatus(for: .video) {
////        case .authorized: // the user has already authorized to access the camera.
////            self.setupCaptureSession()
////
////        case .notDetermined: // the user has not yet asked for camera access.
////            AVCaptureDevice.requestAccess(for: .video) { (granted) in
////                if granted { // if user has granted to access the camera.
////                    print("the user has granted to access the camera")
////                    DispatchQueue.main.async {
////                        self.setupCaptureSession()
////                    }
////                } else {
////                    print("the user has not granted to access the camera")
////                    self.handleDismiss()
////                }
////            }
////
////        case .denied:
////            print("the user has denied previously to access the camera.")
////            self.handleDismiss()
////
////        case .restricted:
////            print("the user can't give camera access due to some restriction.")
////            self.handleDismiss()
////
////        default:
////            print("something has wrong due to we can't access the camera.")
////            self.handleDismiss()
////        }
////    }
////
////    private func setupCaptureSession() {
////        let captureSession = AVCaptureSession()
////
////        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
////            do {
////                let input = try AVCaptureDeviceInput(device: captureDevice)
////                if captureSession.canAddInput(input) {
////                    captureSession.addInput(input)
////                }
////            } catch let error {
////                print("Failed to set input device with error: \(error)")
////            }
////
////            if captureSession.canAddOutput(photoOutput) {
////                captureSession.addOutput(photoOutput)
////            }
////
////            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
////            cameraLayer.frame = self.view.frame
////            cameraLayer.videoGravity = .resizeAspectFill
////            self.view.layer.addSublayer(cameraLayer)
////
////            captureSession.startRunning()
////            self.setupUI()
////        }
////    }
////
////    @objc private func handleDismiss() {
////        DispatchQueue.main.async {
////            self.dismiss(animated: true, completion: nil)
////        }
////    }
////
////    @objc private func handleTakePhoto() {
////        let photoSettings = AVCapturePhotoSettings()
////        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
////            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
////            photoOutput.capturePhoto(with: photoSettings, delegate: self)
////        }
////    }
////
////    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
////        guard let imageData = photo.fileDataRepresentation() else { return }
////        let previewImage = UIImage(data: imageData)
////
////        let photoPreviewContainer = CameraPreview(frame: self.view.frame)
////        photoPreviewContainer.photoImageView.image = previewImage
////        self.view.addSubviews(photoPreviewContainer)
////    }
////}
//

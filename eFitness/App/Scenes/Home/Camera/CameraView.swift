//
//  CameraView.swift
//  eFitness
//
//  Created by Rose Maina on 08/11/2021.
//

import AVFoundation
import UIKit

final class CameraView: UIView {
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

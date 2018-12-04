//
//  TorchMode.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

import AVFoundation
import UIKit

/// Wrapper around `AVCaptureTorchMode`.
public enum TorchMode {
    case on
    case off
    
    /// Returns the next torch mode.
    var next: TorchMode {
        switch self {
        case .on:
            return .off
        case .off:
            return .on
        }
    }
    
    /// Torch mode image.
    var image: UIImage {
        switch self {
        case .on:
            return imageNamed("flashOn")
        case .off:
            return imageNamed("flashOff")
        }
    }
    
    /// Returns `AVCaptureTorchMode` value.
    var captureTorchMode: AVCaptureDevice.TorchMode {
        switch self {
        case .on:
            return .on
        case .off:
            return .off
        }
    }
}


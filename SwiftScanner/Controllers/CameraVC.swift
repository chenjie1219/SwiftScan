//
//  CameraVC.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: class {
    
    func didOutput(_ code:String)
    
    func didReceiveError(_ error: Error)
    
}

public class CameraVC: UIViewController {
    
    weak var delegate:CameraViewControllerDelegate?
    
    lazy var animationImage = UIImage()
    
    lazy var drawLayer:CALayer = {
        let layer = CALayer()
        layer.frame = view.bounds
        self.scanView.layer.addSublayer(layer)
        return layer
    }()
    
    /// 动画样式
    var animationStyle:ScanAnimationStyle = .default{
        didSet{
            if animationStyle == .default {
                animationImage = imageNamed("ScanLine")
            }else{
                animationImage = imageNamed("ScanNet")
            }
        }
    }
    
    lazy var scannerColor:UIColor = .red
    
    public lazy var flashBtn: UIButton = .init(type: .custom)
    
    private var torchMode:TorchMode = .off {
        didSet{
            guard let captureDevice = captureDevice,
                captureDevice.hasFlash else {
                    return
            }
            guard captureDevice.isTorchModeSupported(torchMode.captureTorchMode) else{
                return
            }
            
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.torchMode = torchMode.captureTorchMode
                captureDevice.unlockForConfiguration()
            }catch{}
            
            flashBtn.setImage(torchMode.image, for: .normal)
        }
    }
    
    
    
    /// `AVCaptureMetadataOutput` metadata object types.
    var metadata = [AVMetadataObject.ObjectType]()
    
    // MARK: - Video
    
    /// Video preview layer.
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    /// Video capture device. This may be nil when running in Simulator.
    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    /// Capture session.
    private lazy var captureSession = AVCaptureSession()
    
    lazy var scanView = ScanView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scanView.startAnimation()
        
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        scanView.stopAnimation()
        
    }
    
}



// MARK: - CustomMethod
extension CameraVC {
    
    func setupUI() {
        
        view.backgroundColor = .black
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        
        videoPreviewLayer?.frame = view.layer.bounds
        
        guard let videoPreviewLayer = videoPreviewLayer else {
            return
        }
        
        view.layer.addSublayer(videoPreviewLayer)
        
        scanView.scanAnimationImage = animationImage
        
        scanView.scanAnimationStyle = animationStyle
        
        scanView.cornerColor = scannerColor
        
        view.addSubview(scanView)
        
        setupCamera()
        
        setupTorch()
        
    }
    
    
    /// 创建手电筒按钮
    func setupTorch() {
        
        let buttonSize:CGFloat = 37
        
        flashBtn.frame = CGRect(x: screenWidth - 20 - buttonSize, y: statusHeight + 44 + 20, width: buttonSize, height: buttonSize)
        
        flashBtn.addTarget(self, action: #selector(flashBtnClick), for: .touchUpInside)
        
        flashBtn.isHidden = true
        
        view.addSubview(flashBtn)
        
        view.bringSubviewToFront(flashBtn)
        
        torchMode = .off
        
    }
    
    
    
    // 设置相机
    func setupCamera() {
        
        setupSessionInput()
        
        setupSessionOutput()
        
    }
    
    
    //捕获设备输入流
    private  func setupSessionInput() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        guard let device = captureDevice else {
            return
        }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: device)
            
            captureSession.beginConfiguration()
            
            if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
                captureSession.removeInput(currentInput)
            }
            
            captureSession.addInput(newInput)
            
            captureSession.commitConfiguration()
            
        }catch{
            delegate?.didReceiveError(error)
        }
        
    }
    
    //捕获元数据输出流
    private func setupSessionOutput() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        captureSession.addOutput(videoDataOutput)
        
        let output = AVCaptureMetadataOutput()
        
        captureSession.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        for type in metadata {
            if !output.availableMetadataObjectTypes.contains(type){
                return
            }
        }
        
        output.metadataObjectTypes = metadata
        
        videoPreviewLayer?.session = captureSession
        
        view.setNeedsLayout()
    }
    
    
    
    /// 开始扫描
    func startCapturing() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        captureSession.startRunning()
        
    }
    
    
    /// 停止扫描
    func stopCapturing() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        captureSession.stopRunning()
        
    }
    
    
}




// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension CameraVC:AVCaptureMetadataOutputObjectsDelegate{
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        clearCorners()
        
        stopCapturing()
        
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        for obj in metadataObjects {
            if obj.isKind(of: AVMetadataMachineReadableCodeObject.classForCoder()) {
                let codeObject = self.videoPreviewLayer?.transformedMetadataObject(for: obj)
                drawCorners(codeObject: codeObject as! AVMetadataMachineReadableCodeObject)
            }
        }
        
        delegate?.didOutput(object.stringValue ?? "")
        
    }
    
}



// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraVC:AVCaptureVideoDataOutputSampleBufferDelegate{
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let metadataDict = CMCopyDictionaryOfAttachments(allocator: nil,target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        
        guard let metadata = metadataDict as? [String:Any],
            let exifMetadata = metadata[kCGImagePropertyExifDictionary as String] as? [String:Any],
            let brightnessValue = exifMetadata[kCGImagePropertyExifBrightnessValue as String] as? Double else{
                return
        }
        
        // 判断光线强弱
        if brightnessValue < -1.0 {
            
            flashBtn.isHidden = false
            
        }else{
            
            if torchMode == .on{
                flashBtn.isHidden = false
            }else{
                flashBtn.isHidden = true
            }
            
        }
        
    }
}



// MARK: - Click
extension CameraVC{
    
    @objc func flashBtnClick(sender:UIButton) {
        
        torchMode = torchMode.next
        
    }
    
}

extension CameraVC {
    func drawCorners(codeObject: AVMetadataMachineReadableCodeObject){
        if codeObject.corners.isEmpty {
            return
        }
        
        // 创建一个图层
        let layer = CAShapeLayer()
        // 设置线条宽度
        layer.lineWidth = 4.0
        // 设置画笔颜色
        layer.strokeColor = UIColor.green.cgColor
        // 设置填充颜色
        layer.fillColor = nil
        
        // 创建路径
        let path = UIBezierPath()
        
        var index = 0
        
        // 从corners数组中取出第0个元素，将这个字典中x/y赋值给point
        let point = codeObject.corners.first ?? CGPoint.zero
    
        // 移动到第一个点，作为起点
        path.move(to: point)
        
        // 移动到其他的点
        while index < codeObject.corners.count {
            let point = codeObject.corners[index]
            path.addLine(to: point)
            index = index + 1
        }
        
        // 关闭路径连接首尾结点
        path.close()
        
        // 绘制路径
        layer.path = path.cgPath
        
        // 将绘制好的图层添加到drawLayer上
        self.drawLayer.addSublayer(layer)
        
    }
    
    func clearCorners(){
        if self.drawLayer.sublayers == nil || self.drawLayer.sublayers?.count == 0 {
            return
        }
        
        for layer in self.drawLayer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
    }
}

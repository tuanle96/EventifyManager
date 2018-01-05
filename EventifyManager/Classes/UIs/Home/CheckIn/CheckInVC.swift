//
//  CheckInVC.swift
//  EventifyManager
//
//  Created by Lê Anh Tuấn on 12/30/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import AVFoundation

class CheckInVC: UIViewController {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var infoView = InforDialogVC()
    var isChecking = false
    var loading = UIActivityIndicatorView()
    var previousQRCode: String = ""
    var ticketsChecked = [String]()
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            self.initCamera()
        case .denied:
            self.showAlert("Please go to setting to turn on camera permission", title: "Whoops", buttons: nil)
        case .notDetermined:
            self.requestCameraPermission()
        case .restricted:
            self.showAlert("Please go to setting to turn on camera permission", title: "Whoops", buttons: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.captureSession?.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.captureSession?.stopRunning()
    }
    
    func initCamera() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func requestCameraPermission() {
        //request permission
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { (isAuth) in
            if isAuth {
                self.initCamera()
            } else {
                self.showAlert("Please go to setting to turn on camera permission", title: "Whoops", buttons: nil)
            }
        }
    }
}

extension CheckInVC: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if self.childViewControllers.count != 0 { return }
        
        //check id event
        guard let idEvent = (self.tabBarController as? MyEventTabBarVC)?.myEvent?.id else {
            return
        }
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            checkIn(with: metadataObj.stringValue, and: idEvent)
        }
    }
    
    func checkIn(with qrCode: String, and idEvent: String) {
        
        if self.ticketsChecked.contains(qrCode) { return }
        
        self.loading.showLoadingDialog(self)
        
        self.ticketsChecked.append(qrCode)
        
        OrderServices.shared.checkOrder(with: qrCode, and: idEvent) { (info, error) in
            
            self.loading.stopAnimating()
            
            self.qrCodeFrameView?.frame = CGRect.zero
            
            if let error = error {
                self.showAlert(error, title: "Whoops", buttons: nil)
                return
            }
            
            guard let info = info else {
                self.showAlert("No informations", title: "Whoops", buttons: nil)
                return
            }
            
            self.infoView.info = info
            self.view.bringSubview(toFront: self.infoView.view)
            self.addChildViewController(self.infoView)
            self.infoView.view.frame = self.view.frame
            self.view.addSubview(self.infoView.view)
            self.infoView.didMove(toParentViewController: self)
            
        }
    }
}

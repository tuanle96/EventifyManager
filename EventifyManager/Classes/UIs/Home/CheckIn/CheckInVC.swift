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
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
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

        //required input permission
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInDualCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.back)
        
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .denied, .notDetermined, .restricted:
            print("CAMERA NOT FOUND")
            return
        default:
            do {
                //input
                let input = try AVCaptureDeviceInput(device: captureDevice)
                self.captureSession = AVCaptureSession()
                self.captureSession?.addInput(input)
                
                //output
                let output = AVCaptureMetadataOutput()
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = self.supportedCodeTypes
                
                self.captureSession?.addOutput(output)
                
                //init preview player
                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                self.videoPreviewLayer?.frame = self.view.layer.bounds
                self.view.layer.addSublayer(self.videoPreviewLayer!)
                
                //init highlight qrcode
                self.qrCodeFrameView = UIView()
                self.qrCodeFrameView?.layer.borderColor = UIColor.blue.cgColor
                self.qrCodeFrameView?.layer.borderWidth = 1
                self.view.addSubview(self.qrCodeFrameView!)
                self.view.bringSubview(toFront: self.qrCodeFrameView!)
                
                //start session
                self.captureSession?.startRunning()
                
                
            } catch let e {
                print(e.localizedDescription)
            }
        }
        
        //init session
        
        //start capture
        
    }
    
    
}

extension CheckInVC: AVCaptureMetadataOutputObjectsDelegate { 
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
    }
}

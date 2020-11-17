//
//  ViewController.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 05/08/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseAuth

class CameraViewController: UIViewController, Storyboarded {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    weak var coordinator: MainCoordinator?
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var user: User!
    var flashOption: Bool = true
    var cameraChange: Bool = true //true is back, false is front
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gatherCurrentUserInfo()
        setupCamera(position: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func gatherCurrentUserInfo() {
        guard let currentUser = Auth.auth().currentUser else { self.viewAlert(message: "Try again later"); return }
        FirebaseDatabase.shared.getUserData(userId: currentUser.uid) { (user) in
            self.user = user
        }
    }
    
    func setupCamera(position: AVCaptureDevice.Position?) {
        var captureDevice: AVCaptureDevice!
        if let position = position {
            captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)!
        } else {
            captureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
            
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = view.layer.frame
            previewView.layer.insertSublayer(videoPreviewLayer!, at: 0)
            captureSession?.startRunning()
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            captureSession?.addOutput(capturePhotoOutput!)
        } catch {
            print(error)
            self.viewAlert(message: "We weren't able to setup Your camera.")
        }
    }
    
    func reloadCamera() {
        captureSession?.stopRunning()
        videoPreviewLayer?.removeFromSuperlayer()
        if cameraChange == true {
            setupCamera(position: .front)
            cameraChange = false
        } else {
            setupCamera(position: .back)
            cameraChange = true
        }
        
    }

    @IBAction func tappedOnCaptureButton(_ sender: UIButton) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { self.viewAlert(message: "Try again later"); return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        
        if flashOption == true {
            photoSettings.flashMode = .on
        } else {
            photoSettings.flashMode = .off
        }
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func tappedOnFriendsButton(_ sender: UIButton) {
        guard let user = user else { self.viewAlert(message: "Try again later"); return }
        coordinator?.showFriendsList(currentUser: user)
    }
    
    
    @IBAction func tappedOnFlashButton(_ sender: UIButton) {
        if flashButton.currentImage == UIImage(systemName: "bolt.slash.fill") {
            print("bolt przekreslony - zmienic na zwykly")
            flashButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
            flashOption = true
        } else if flashButton.currentImage == UIImage(systemName: "bolt.fill") {
            flashButton.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
            flashOption = false
        }
    }
    
    
    @IBAction func tappedOnCameraButton(_ sender: UIButton) {
        reloadCamera()
    }
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        coordinator?.capturedPhoto(photo: photo, currentUser: user)
    }
}


//
//  LoginViewController.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 06/08/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var coordinator: MainCoordinator?
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundVideo()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func createAccountButtonTouched(_ sender: UIButton) {
        coordinator?.createNewAccount()
    }
    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            self.viewAlert(message: "Try again later");
            return
        }
        Loader.start(view: self.view)
        FirebaseAuthentication.shared.loginUser(email: email, password: password) { (logged) in
            Loader.stop()
            if logged {
                self.coordinator?.loginSuccessful()
            } else {
                self.viewAlert(message: "Please check Your credentials or internet connection once again.")
            }
        }
    }
    
}

extension LoginViewController {
    func playBackgroundVideo() {
        let path = Bundle.main.path(forResource: "bgvid2", ofType: ".mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player!.actionAtItemEnd = .none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.view.frame
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true
            
    }
            
    @objc func playerDidReachEnd() {
        player!.seek(to: CMTime.zero)
    }
}

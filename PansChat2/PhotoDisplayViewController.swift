//
//  PhotoDisplayViewController.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 05/08/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoDisplayViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var imageView: UIImageView!
    
    weak var coordinator: MainCoordinator?
    
    var capturePhoto: AVCapturePhoto!
    var currentUser: User!
    var imageData: Data?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processPhoto()
        // Do any additional setup after loading the view.
    }
    
    func processPhoto() {
        guard let imageData = capturePhoto.fileDataRepresentation() else {
            return
        }
        
        self.imageData = imageData
        
        guard let uiImage = UIImage(data: imageData) else {
            return
        }
        imageView.image = uiImage
        image = uiImage
    }
    
    
    @IBAction func sendPhotoActionButton(_ sender: UIButton) {
        guard let image = image else { return }
        guard let data = image.jpegData(compressionQuality: 0.1) else { return }
        coordinator?.showFriendsListToSendPhoto(photoData: data, currentUser: currentUser)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

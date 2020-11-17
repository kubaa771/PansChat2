//
//  PhotoViewerViewController.swift
//  PansChat2
//
//  Created by Jakub Iwaszek on 11/10/2020.
//

import UIKit

class PhotoViewerViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var photoDisplayImageVIew: UIImageView!
    var imageData: Data!
    var photos: [Photo]!
    var currentUser: User!
    var i = 0;
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPhoto(photoData: photos.first!.photoData!)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayNextPhoto))
        view.addGestureRecognizer(tap)
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    func displayPhoto(photoData: Data) {
        print(photos.count)
        photoDisplayImageVIew.image = UIImage(data: photoData)
    }
    
    @objc func displayNextPhoto() {
        if i >= (photos.count-1){
            print("end of the photos array")
            let currentPhotoId = photos[i].id!
            removeSeenPhoto(photoId: currentPhotoId)
            self.navigationController?.isNavigationBarHidden = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshFriendsTableView"), object: nil)
            navigationController?.popViewController(animated: true)
        } else {
            let currentPhotoId = photos[i].id!
            removeSeenPhoto(photoId: currentPhotoId)
            i+=1
            let nextImage = photos[i].photoData!
            displayPhoto(photoData: nextImage)
            
        }
    }
    
    func removeSeenPhoto(photoId: String) {
        print(photoId)
        FirebaseDatabase.shared.removeSeenPhotoFromUser(userId: currentUser.id, photoId: photoId)
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

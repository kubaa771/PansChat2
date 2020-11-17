//
//  MainCoordinator.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 06/08/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
    
class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.isTranslucent = true
    }
    
    func start() {
        let vc = LoginViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func createNewAccount() {
        let vc = RegisterViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func loginSuccessful() {
        let vc = CameraViewController.instantiate()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }
    
    
    func capturedPhoto(photo: AVCapturePhoto, currentUser: User){
        let vc = PhotoDisplayViewController.instantiate()
        vc.coordinator = self
        vc.currentUser = currentUser
        vc.capturePhoto = photo
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFriendsList(currentUser: User) {
        let vc = FriendsViewController.instantiate()
        vc.coordinator = self
        vc.user = currentUser
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openAddNewFriendsVC(currentUser: User) {
        let vc = AddNewFriendsViewController.instantiate()
        vc.coordinator = self
        vc.currentUser = currentUser
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFriendsListToSendPhoto(photoData: Data, currentUser: User) {
        let vc = SendToFriendsViewController.instantiate()
        vc.coordinator = self
        vc.currentUser = currentUser
        vc.imageData = photoData
        navigationController.pushViewController(vc, animated: true)
    }

    func displayPhoto(photos: [Photo], currentUser: User) {
        let vc = PhotoViewerViewController.instantiate()
        vc.coordinator = self
        vc.currentUser = currentUser
        vc.photos = photos
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}

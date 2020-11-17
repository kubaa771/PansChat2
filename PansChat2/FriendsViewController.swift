//
//  FriendsViewController.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 11/08/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: MainCoordinator?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .darkContent
    }
    
    var user: User!
    var friendsList: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewFriendsButton()
        fetchFriendsData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFriendsData), name: NSNotification.Name(rawValue: "RefreshFriendsTableView"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func setupNewFriendsButton() {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFriendsButton))
        self.navigationController?.navigationItem.rightBarButtonItem = buttonItem
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    
    @objc func addNewFriendsButton() {
        coordinator?.openAddNewFriendsVC(currentUser: user)
    }
    
    @objc func fetchFriendsData() {
        guard let user = user else { return }
        FirebaseDatabase.shared.getUserFriends(user: user) { (friends) in
            guard let friends = friends else { return }
            Loader.start(view: self.view)
            self.friendsList = friends
            self.fetchPhotoInformation()
        }
    }
    
    func fetchPhotoInformation() {
        FirebaseDatabase.shared.downloadPhotos(for: user) { (photosArray) in
            print(photosArray)
            for friend in self.friendsList {
                if photosArray.contains(where: { (photo) -> Bool in
                    if photo.fromUserId == friend.id {
                        return true
                    } else {
                        return false
                    }
                    return true
                }){
                    for photo in photosArray {
                        if photo.fromUserId == friend.id {
                            friend.photos.append(photo)
                        }
                    }
                    friend.hasPhotos = true
                }
            }
            DispatchQueue.main.async {
                Loader.stop()
                self.tableView.reloadData()
            }
        }
    }
    
    func getPhotoFromUser(friendUser: User) {
        guard !friendUser.photos.isEmpty else { return }
        //let photo = friendUser.photos[0] //kiedys zrobic for photo in friendUser.photos { }
        let group = DispatchGroup()
        var photos: [Photo] = []
        
        for photo in friendUser.photos {
            group.enter()
            FirebaseDatabase.shared.getPhoto(photoId: photo.id) { (photoDict) in
                var photoData = photoDict["photoData"] as! Data
                var photoTimeCreated = photoDict["timeCreated"] as! Date
                photo.photoData = photoData
                photo.timeCreated = photoTimeCreated
                photos.append(photo)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [self] in
            photos.sort(by: {$0.timeCreated! < $1.timeCreated!})
            self.coordinator?.displayPhoto(photos: photos, currentUser: user)
        }
    }
    
   
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
        cell.isFriendList = true
        cell.model = friendsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
        if cell.model.hasPhotos {
            getPhotoFromUser(friendUser: cell.model)
            //coordinator?.displayPhoto(photoData: <#T##Data#>, currentUser: <#T##User#>)
        }
    }
    
    
}

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .darkContent
   }
}

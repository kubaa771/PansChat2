//
//  AddNewFriendsViewController.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 15/08/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit

class AddNewFriendsViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var tableView: UITableView!
    
    var currentUser: User!
    
    var allUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    
    func getAllUsers() {
        Loader.start(view: self.view)
        FirebaseDatabase.shared.getAllUsers { (allUsers) in
            guard let allUsers = allUsers else { return }
            self.allUsers = allUsers
            Loader.stop()
            self.tableView.reloadData()
        }
    }

}

extension AddNewFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
        cell.isFriendList = false
        cell.delegate = self
        cell.model = allUsers[indexPath.row]
        return cell
    }
    
    
}

extension AddNewFriendsViewController: FriendsListsProtocol {
    
    func tappedAddFriendButton(cell: FriendsTableViewCell) {
        FirebaseDatabase.shared.addUserToCurrentUserFriendList(user: cell.model) { (completion) in
            print("dodany")
        }
        print(cell.friendNameLabel)
    }
    
    
}

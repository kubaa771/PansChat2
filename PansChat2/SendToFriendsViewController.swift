//
//  SendToFriendsViewController.swift
//  PansChat2
//
//  Created by Jakub Iwaszek on 01/10/2020.
//

import UIKit

class SendToFriendsViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    var friendsList: [User] = []
    var currentUser: User!
    weak var coordinator: MainCoordinator?
    var imageData: Data!
    var selectedUsers: [Int : User] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        fetchFriendsData()
    }
    
    func fetchFriendsData() {
        guard let currentUser = currentUser else { return }
        FirebaseDatabase.shared.getUserFriends(user: currentUser) { (friends) in
            guard let friends = friends else { return }
            self.friendsList = friends
            self.tableView.reloadData()
        }
    }
    

    @IBAction func sendToUsersButtonAction(_ sender: UIButton) {
        print(selectedUsers.count)
        if !selectedUsers.isEmpty {
            Loader.start(view: self.view    )
            FirebaseDatabase.shared.sendPhotoToUsers(fromUser: currentUser, toUsers: selectedUsers, photoData: imageData) { (checker) in
                Loader.stop()
                if checker {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }

}

extension SendToFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
        cell.isFriendList = true
        //dac inne zdjecie cell
        cell.model = friendsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
        cell.contentView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        selectedUsers.updateValue(cell.model, forKey: indexPath.row) //cos z indexem?
        print(selectedUsers)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
        cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        selectedUsers.removeValue(forKey: indexPath.row)
        print(selectedUsers)
    }
    
    
}

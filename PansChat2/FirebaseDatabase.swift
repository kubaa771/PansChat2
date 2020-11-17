//
//  FirebaseDatabase.swift
//  PansChat2
//
//  Created by Jakub Iwaszek on 30/09/2020.
//

import Foundation
import Firebase

class FirebaseDatabase {
    static let shared = FirebaseDatabase()
    
    var ref: DatabaseReference! = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    func getUserData(userId: String,completion: @escaping (User?) -> Void) {
        ref.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let dataDict = snapshot.value as? NSDictionary {
                guard let email = dataDict["email"] as? String else {
                    print("error email parsing")
                    return
                }
                let user = User(id: userId, email: email)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func getAllUsers(completion: @escaping ([User]?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        var users: [User] = []
        
        ref.child("users").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else { return }
                if let childValue = childSnapshot.value as? NSDictionary {
                    let id = childValue["id"] as! String
                    if id != currentUser.uid {
                        let email = childValue["email"] as! String
                        let user = User(id: id, email: email)
                        users.append(user)
                    }
                }
            }
            completion(users)
        }
    }
    
    func addUserToCurrentUserFriendList(user: User, completion: @escaping (Bool) -> Void) { //bez completion?
        guard let currentUser = Auth.auth().currentUser else { return }
        
        ref.child("users").child(currentUser.uid).child("friends").updateChildValues([user.id : user.id])
        
        
    }
    
    func getUserFriends(user: User, completion: @escaping ([User]?) -> Void) {
        var group = DispatchGroup()
        var friends: [User] = []
        
        ref.child("users").child(user.id).child("friends").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else { return }
                group.enter()
                let id = childSnapshot.key
                self.getUserData(userId: id) { (user) in
                    guard let user = user else { return }
                    friends.append(user)
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(friends)
            }
        }
    }
    
    func sendPhotoToUsers(fromUser: User, toUsers: [Int:User], photoData: Data, completion: @escaping (Bool) -> Void) {
        /*let string = photoData.base64EncodedString()
        let data = Data(base64Encoded: string)*/
        let generatedPhotoID = UUID().uuidString
        //uzyc firebase storage i przechowywac jako img - uzywac reference
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        //metadata.customMetadata = ["from": fromUser.id, "to": (toUsers.first?.value.id)!] //przerobic na wielu userow FOR?
        
        storageRef.child(generatedPhotoID).putData(photoData, metadata: nil) { (metadata, err) in
            guard let metadata = metadata else {
                print("metadata storage error")
                completion(false)
                return
            }
            completion(true)
        }
        
        ref.child("photos").child(generatedPhotoID).updateChildValues(["from": fromUser.id])
        for toUser in toUsers {
            ref.child("photos").child(generatedPhotoID).child("to").updateChildValues([toUser.value.id:toUser.value.id])
        }
        
      
    }
    
    func downloadPhotos(for user: User, completion: @escaping ([Photo]) -> Void) {
        var fromUsersPhotoDict: [Photo] = []
        
        ref.child("photos").observeSingleEvent(of: .value) { (snapshot) in
            let children = snapshot.children
            for child in children {
                guard let childSnapshot = child as? DataSnapshot else { return }
                if let valueDict = childSnapshot.value as? NSDictionary {
                    let idFrom = valueDict["from"] as! String
                    guard let idToDict = valueDict["to"] as? NSDictionary else { return }
                    for idToChild in idToDict {
                        let idToString = idToChild.key as! String
                        if user.id == idToString {
                            let photo = Photo(id: childSnapshot.key, fromUserId: idFrom, toUserId: idToString)
                            fromUsersPhotoDict.append(photo)
                        }
                    }
                }
            }
            completion(fromUsersPhotoDict)
        }
    }
    
    func getPhoto(photoId: String, completion: @escaping ([String:Any]) -> Void) {
        var photoInfo: [String: Any] = [:]
        var group = DispatchGroup()
        group.enter()
        storageRef.child(photoId).getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error != nil {
                print("error while gathering photo data")
            } else {
                guard let data = data else { /*completion nil*/return }
                photoInfo.updateValue(data, forKey: "photoData")
                group.leave()
            }
        }
        group.enter()
        storageRef.child(photoId).getMetadata { (metadata, error) in
            if error != nil {
                print("error while gathering photo metadata")
            } else {
                guard let date = metadata?.timeCreated else { return }
                photoInfo.updateValue(date, forKey: "timeCreated")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(photoInfo)
        }
    }
    
    func removeSeenPhotoFromUser(userId: String, photoId: String) {
        ref.child("photos").child(photoId).child("to").child(userId).removeValue { (error, childref) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("removed")
                childref.parent?.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChildren() {
                        print("true")
                    } else {
                        print("false")
                        self.ref.child("photos").child(photoId).removeValue()
                        self.removePhotoFromStorage(photoId: photoId)
                    }
                })
                
            }
        }
    }
    
    func removePhotoFromStorage(photoId: String) {
        storageRef.child(photoId).delete { (error) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
}

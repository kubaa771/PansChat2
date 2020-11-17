//
//  FirebaseAuthentication.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 06/08/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseAuthentication {
    static let shared = FirebaseAuthentication()
    var ref: DatabaseReference! = Database.database().reference()
    
    func registerUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error1")
                completion(false)
            } else {
                //dodanie danych usera do bazy
                self.ref.child("users").child((result?.user.uid)!).setValue(["email": email, "id": String((result?.user.uid)!)])
                completion(true)
            }
            
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error2")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    }

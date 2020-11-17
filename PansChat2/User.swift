//
//  User.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 12/08/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import Foundation

class User {
    var id: String
    var email: String
    var hasPhotos: Bool = false
    var isFriend: Bool?
    var photos: [Photo] = []
    
    init(id: String, email: String) {
        self.id = id
        self.email = email
    }
}

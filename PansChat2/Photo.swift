//
//  Photo.swift
//  PansChat2
//
//  Created by Jakub Iwaszek on 14/10/2020.
//

import Foundation

class Photo {
    var id: String!
    var fromUserId: String!
    var toUserId: String! //in future [String]
    var photoData: Data?
    var timeCreated: Date?
    
    init(id: String, fromUserId: String, toUserId: String) {
        self.id = id
        self.fromUserId = fromUserId
        self.toUserId = toUserId
    }
}

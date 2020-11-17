//
//  Protocols.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 10/09/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import Foundation
import UIKit

protocol FriendsListsProtocol: AnyObject {
    func tappedAddFriendButton(cell: FriendsTableViewCell)
}

extension UIViewController {
    func viewAlert(message: String) {
        let alert = UIAlertController(title: "Something went wrong...", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

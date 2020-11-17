//
//  FriendsTableViewCell.swift
//  PansChat
//
//  Created by Jakub Iwaszek on 12/08/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var photoCheckerImageView: UIImageView?
    @IBOutlet weak var addButton: UIButton!
    
    var model: User! {
        didSet {
            customize(model: model)
        }
    }
    
    var isFriendList: Bool!
    weak var delegate: FriendsListsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customize(model: User) {
        self.layer.cornerRadius = 20
        friendNameLabel.text = model.email
        if !isFriendList {
            addButton.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
        }
        
        if model.hasPhotos && photoCheckerImageView != nil{
            photoCheckerImageView?.image = UIImage(systemName: "paperplane.fill")
        } else {
            photoCheckerImageView?.image = UIImage(systemName: "paperplane")
        }
        self.setNeedsDisplay()
        //zmienic zdjecie tylko jesli jest nil
        
    }
    
    @objc func addFriend() {
        delegate?.tappedAddFriendButton(cell: self)
    }

}

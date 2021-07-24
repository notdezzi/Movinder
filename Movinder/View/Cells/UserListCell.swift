//
//  UserListCell.swift
//  Movinder
//
//  Created by Max on 09.03.21.
//

import UIKit
import SDWebImage

protocol UserListCellDelegate: class {
    func handleAddUser()
}

class UserListCell: UICollectionViewCell {
    
    weak var delegate: UserListCellDelegate?
    
    
    var friend: Friend? {
        didSet {
            configureCell()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "photo_placeholder")
        iv.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    private let listImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "list.dash")!.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .systemGray4
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.tintColor = .black
        return label
    }()
    
    static var cellId = "userListCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 8, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 50 / 2
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8)
        
        addSubview(listImageView)
        listImageView.setDimensions(height: 30, width: 30)
        listImageView.anchor(right: rightAnchor, paddingRight: 18)
        listImageView.centerYToSuperview()
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        addSubview(separatorView)
        separatorView.anchor(left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
    }
    
    var imageicon: UIImage?
    
    private func configureCell() {
        usernameLabel.text = friend?.username
        if (friend?.profileimageUrl) != nil {
            let imageUrl = URL(string: friend!.profileimageUrl)
            let loaded = false
            if loaded == false {
                if imageicon == nil {
                    imageicon = #imageLiteral(resourceName: "photo_placeholder")
                }
            }else{
                }
            SDWebImageManager.shared().loadImage(with: imageUrl, options: .continueInBackground, progress: nil){
                (image, _,_,_,_,_) in
                self.profileImageView.image = image
            }
        } else {
            profileImageView.image = #imageLiteral(resourceName: "photo_placeholder")
        }
    }
    
    func saveAddAndCheckForRequest(forUser user:User, didLike: Bool){
        Service.sendFriendRequest(forUser: user, isAccepted: didLike) { error in
            guard didLike == true else {return}
            
            Service.friendRequest(forUser: user) { didMatch in
//                Service.addFriendToArray(forUser: user, isFriends: didMatch)
                print(didMatch)
        }
        }
    }
    
}

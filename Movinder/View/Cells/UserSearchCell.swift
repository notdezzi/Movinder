//
//  UserSearchCell.swift
//  Movinder
//
//  Created by Max on 08.03.21.
//

import UIKit
import Firebase
import SDWebImage

protocol UserSearchCellDelegate: class {
    func handleAddUser()
}

class UserSearchCell: UICollectionViewCell {
    
    weak var delegate: UserSearchCellDelegate?
    
    
    var user: User? {
        didSet {
            configureCell()
        }
    }
    var currentUser: User? {
        didSet {
        }
    }
    
    lazy var button = createButton()
    
    func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("+ Add", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.setDimensions(height: 70, width: 70)
        //button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleAddUser), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray2.cgColor
        return button
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "photo_placeholder")
        iv.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        iv.layer.borderWidth = 0.5
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    static var cellId = "userSearchCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
        fetchUser()
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
        
        addSubview(button)
        button.setDimensions(height: 20, width: 70)
        button.centerYToSuperview()
        button.anchor(right: safeAreaLayoutGuide.rightAnchor, paddingRight: 15)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        addSubview(separatorView)
        separatorView.anchor(left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
    }
    
    var imageicon: UIImage?
    
    private func configureCell() {
        usernameLabel.text = user?.username
        if (user?.profileImageUrl) != nil {
            let imageUrl = URL(string: user!.profileImageUrl)
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
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
    func saveAddAndCheckForRequest(forUser user:User, didLike: Bool){
        Service.sendFriendRequest(forUser: user, isAccepted: didLike) { error in
            guard didLike == true else {return}
            
            Service.friendRequest(forUser: user) { didMatch in
                
                guard let currentUser = self.currentUser else {return}
                print(currentUser.uid)
                Service.addFriendToArray(currentUser: currentUser, matchedUser: user)
        }
        }
    }
    
    @objc func handleAddUser(){
        delegate?.handleAddUser()
        saveAddAndCheckForRequest(forUser: self.user!, didLike: true)
    }
}

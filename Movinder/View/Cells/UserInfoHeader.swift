//
//  UserInfoHeader.swift
//  Movinder
//
//  Created by Max on 21.03.21.
//

import UIKit
import SDWebImage

class UserInfoHeader: UIView {
    
    var imageicon: UIImage?
    let user: User
    
    // MARK: - Properties
    
    public let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "lady4c")
        return iv
    }()
    public let placeholderImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "photo_placeholder")
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tony Stark"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    init(frame: CGRect, user: User) {
        self.user = user
        super.init(frame: frame)
        
        let profileImageDimension: CGFloat = 60
        
        let imageUrl = URL(string: user.profileImageUrl)
        
        SDWebImageManager.shared().loadImage(with: imageUrl, options: .continueInBackground, progress: nil){
            (image, _,_,_,_,_) in
            self.placeholderImageView.image = image
        }
        
        addSubview(placeholderImageView)
        placeholderImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        placeholderImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        placeholderImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        placeholderImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        placeholderImageView.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        usernameLabel.text = user.username
        
        addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        emailLabel.text = user.bio
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

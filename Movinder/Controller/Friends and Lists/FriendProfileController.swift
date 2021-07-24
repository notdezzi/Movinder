//
//  FriendProfileController.swift
//  Movinder
//
//  Created by Max on 21.03.21.
//

import UIKit
import SDWebImage

class FriendProfileController: UIViewController {
    
    // MARK: - Properties
    let user: User
    var currentUser: User? {
        didSet {
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 44,
                                width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        
        view.addSubview(messageButton)
        messageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                             paddingTop: 22, paddingLeft: 32, width: 32, height: 32)
        
        view.addSubview(followButton)
        followButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor,
                            paddingTop: 22, paddingRight: 32, width: 32, height: 32)
        
        view.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        
        view.addSubview(bioLabel)
        bioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bioLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: 4)
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "photo_placeholder")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.gray.cgColor
        return iv
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.bullet.rectangle"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleMessageUser), for: .touchUpInside)
        return button
    }()
    
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.fill.badge.plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleAddUser), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Eddie Brock"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .black
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "venom@gmail.com"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
        let imageUrl = URL(string: user.profileImageUrl)
        
        SDWebImageManager.shared().loadImage(with: imageUrl, options: .continueInBackground, progress: nil){
            (image, _,_,_,_,_) in
            self.profileImageView.image = image
        }
        nameLabel.text = user.username
        bioLabel.text = user.bio
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Selectors
    
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
    
    @objc func handleMessageUser() {
        Service.fetchFriends { [self] (friends) in
            friends.forEach { (Friend) in
                if Friend.uid == self.user.uid {
                    navigationController?.pushViewController(ListController(user: user, friend: Friend), animated: true)
                }else{
                    let alertController:UIAlertController = UIAlertController(title: "Can't View List", message: "Must be friends with this User in order to see List", preferredStyle: UIAlertController.Style.alert)
                    let alertAction:UIAlertAction = UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler:nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @objc func handleAddUser() {
        saveAddAndCheckForRequest(forUser: user, didLike: true)
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let mainBlue = UIColor.rgb(red: 0, green: 150, blue: 255)
}

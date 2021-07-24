//
//  UserProfileController.swift
//  Movinder
//
//  Created by Max on 09.03.21.
//

import UIKit
protocol UserProfileControllerDelegate: class {
    func userProfileController(_ controller: UserProfileController, didLikeMovie user: User)
    func userProfileController(_ controller: UserProfileController, didDislikeMovie user: User)
}
class UserProfileController: UIViewController {
    
    //MARK: Properties
    
    private let user: User
    weak var delegate: UserProfileControllerDelegate?
    
    
    private lazy var imageView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        let v = UIView(frame: frame)
        v.backgroundColor = .systemGroupedBackground
        let imageView = UIImageView(frame: frame)
        let imageURL = NSURL(string: user.profileImageUrl)
        let imagedData = NSData(contentsOf: imageURL! as URL)!
        imageView.image = UIImage(data: imagedData as Data)?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let dissmissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    //MARK: LABELS
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24,weight: .semibold)
        return label
    }()
    
    private let infoLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let lengthLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let ratingLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let releasedLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //MARK: BUTTONS
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "like_circle"))
//        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var superlikeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "super_like_circle"))
//        button.addTarget(self, action: #selector(handleSuperlike), for: .touchUpInside)
        return button
    }()
    
    private lazy var dislikeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "dismiss_circle"))
//        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        return button
    }()
    //MARK: Lifecycle
    init(user: User){
        self.user = user
        self.userName = user.name
        self.userBio = user.bio
        self.userUsername = user.username
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: Helpers
    
    let userName : String
    let userBio : String
    let userUsername : String
    
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(dissmissButton)
        dissmissButton.setDimensions(height: 40, width: 40)
        dissmissButton.anchor(top: imageView.bottomAnchor,right: view.rightAnchor, paddingTop: -20 , paddingRight: 16)
        nameLabel.text = "" + userName
        lengthLabel.text = "Bio: " + userBio
        infoLabel.text = "Usernane: " + userUsername
        let infoStack = UIStackView(arrangedSubviews: [nameLabel,infoLabel,lengthLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        view.addSubview(infoStack)
        infoStack.anchor(top: imageView.bottomAnchor , left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12,paddingRight: 12)
        configureBottomControls()
    }
    
    func configureBottomControls(){
        let stack = UIStackView(arrangedSubviews: [likeButton,superlikeButton,dislikeButton])
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.spacing = -32
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
    }
    
    func createButton(withImage image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
}

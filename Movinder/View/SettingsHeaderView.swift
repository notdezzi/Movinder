//
//  SettingsHeaderView.swift
//  Movinder
//
//  Created by Max on 03.03.21.
//

import UIKit
import SDWebImage

protocol SettingsHeaderViewDelegate: class {
    func settingsHeaderView(header: SettingsHeaderView, didSelect index: Int)
}

class SettingsHeaderView: UIView{
    
    private let user: User
    
    //MARK: Properties
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: SettingsHeaderViewDelegate?
    
    //MARK: Lifecycle
    
    lazy var button = createButton()
    init(user: User){
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        
        addSubview(button)
        
        addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: button.rightAnchor, constant: 12).isActive = true
        emailLabel.text = "Change your username and add an \nprofile picture"
        
        button.centerYToSuperview()
        button.anchor(left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 15)
        button.setDimensions(height: 75, width: 75)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Helpers
    
    func configure(){
        
        let imageUrl = URL(string: user.profileImageUrl)
        
        SDWebImageManager.shared().loadImage(with: imageUrl, options: .continueInBackground, progress: nil){
            (image, _,_,_,_,_) in
            self.button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    
    
    //MARK: Functions
    
    @objc func handleUserSettings(sender: UIButton){
        print("DEBUG: USERSETTINGS")
    }
    
    @objc func handleSelectPhoto(sender: UIButton){
        delegate?.settingsHeaderView(header: self, didSelect: sender.tag)
    }
    
    //MARK: Helpers
    
    func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 37
//        button.setDimensions(height: 125, width: 125)
        //button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }
    
    
}


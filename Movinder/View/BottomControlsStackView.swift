//
//  BottomControlsStackView.swift
//  Movinder
//
//  Created by Max on 26.02.21.
//

import UIKit

protocol BottomControlsStackViewDelegate: class {
    func handleLike()
    func handleDislike()
    func handleRefresh()
    func handleShowLiked()
}

class BottomControlsStackView: UIStackView {
    
    //MARK: - PROPERTIES
    
    weak var delegate: BottomControlsStackViewDelegate?
    
    let refreshButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superlikeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    //MARK: Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        distribution = .fillEqually
        
        refreshButton.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        superlikeButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(#imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        
        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        superlikeButton.addTarget(self, action: #selector(handleShowLiked), for: .touchUpInside)
        
        [refreshButton, likeButton, superlikeButton,
         dislikeButton, boostButton].forEach {
            view in addArrangedSubview(view)
         }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: HELPERS
    
    @objc func handleRefresh(){
        delegate?.handleRefresh()
    }
    @objc func handleLike(){
        delegate?.handleLike()
    }
    @objc func handleDislike(){
        delegate?.handleDislike()
    }
    @objc func handleShowLiked(){
        delegate?.handleShowLiked()
    }
}

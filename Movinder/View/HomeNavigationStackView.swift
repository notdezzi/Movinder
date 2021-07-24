//
//  HomeNavigationStackView.swift
//  Movinder
//
//  Created by Max on 25.02.21.
//

import UIKit

protocol HomeNavigationStackViewDelegate: class {
    func showSettings()
    func showMessages()
}

class HomeNavigationStackView: UIStackView {
    
    //MARK: - PROPERTIES
    
    weak var delegate: HomeNavigationStackViewDelegate?
    
    let settingsButton = UIButton(type: .system)
    let messagebutton = UIButton(type: .system)
    let tinderIcon = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    //MARK: Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        
        settingsButton.setImage(#imageLiteral(resourceName: "usersettings").withRenderingMode(.alwaysOriginal), for: .normal)
        messagebutton.setImage(#imageLiteral(resourceName: "friends").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [messagebutton, UIView(), tinderIcon,
         UIView(), settingsButton].forEach {
            view in addArrangedSubview(view)
         }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 3, bottom: 0, right: -10)
        
        settingsButton.addTarget(self, action: #selector(handleShowSettings), for: .touchUpInside)
        messagebutton.addTarget(self, action: #selector(handleShowMessages), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleShowSettings(){
        delegate?.showSettings()
    }
    
    @objc func handleShowMessages(){
        delegate?.showMessages()
    }
}

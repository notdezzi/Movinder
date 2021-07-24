//
//  SettingsFooter.swift
//  Movinder
//
//  Created by Max on 21.03.21.
//

import UIKit

protocol SettingsFooterDelegate: class {
    func handleLogout()
}

class SettingsFooter: UIView {
    
    weak var delegate: SettingsFooterDelegate?
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let spacer = UIView()
        spacer.backgroundColor = .systemGroupedBackground
        
        addSubview(spacer)
        spacer.setDimensions(height: 32, width: frame.width)
        
        addSubview(logOutButton)
        logOutButton.anchor(top: spacer.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleLogOut(){
        delegate?.handleLogout()
    }
}

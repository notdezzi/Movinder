//
//  AuthButton.swift
//  Movinder
//
//  Created by Max on 26.02.21.
//

import UIKit

class AuthButton: UIButton {
    
    init(title: String, type: ButtonType){
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

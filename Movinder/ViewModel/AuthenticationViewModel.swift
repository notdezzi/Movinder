//
//  AuthenticationViewModel.swift
//  Movinder
//
//  Created by Max on 27.02.21.
//

import Foundation

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationViewModel {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}

struct RegistrationViewModel: AuthenticationViewModel {
    
    var username: String?
    var email: String?
    var fullName: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && username?.isEmpty == false && fullName?.isEmpty == false && password?.isEmpty == false
    }
}

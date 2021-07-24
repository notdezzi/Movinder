//
//  AuthService.swift
//  Movinder
//
//  Created by Max on 27.02.21.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let username: String
    let password: String
    let fullName: String
    let profileImage: UIImage
}

struct AuthService {
    
    static func logUserIn(withEmail email: String, withPassword password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping((Error?) -> Void)){
        
        Service.uploadImage(image: credentials.profileImage) { imageUrl in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) {
                (result, error) in 
                if let error = error {
                    print("DEBUG: Error Signing up user \(error.localizedDescription)")
                    return
                }
                guard let uid = result?.user.uid else { return }
                
                let data = ["email": credentials.email,
                            "username": credentials.username,
                            "fullname": credentials.fullName,
                            "imageUrl": imageUrl,
                            "uid": uid,
                            "age": 18] as [String : Any]
            
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
            
        }
        
    }

}

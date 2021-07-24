//
//  User.swift
//  Movinder
//
//  Created by Max on 26.02.21.
//

import UIKit

struct User {
    var name: String
    var username: String
    var age: Int
    var bio: String
    let email: String
    let uid: String
    let profileImageUrl: String
    let requests: [Bool]
    let friends: [String]
    
    init(dictionary: [String: Any]){
        self.name = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["imageUrl"] as? String ?? ""
        self.requests = dictionary["requests"] as? [Bool] ?? [false]
        self.friends = dictionary["friends"] as? [String] ?? [""]
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

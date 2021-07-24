//
//  Friend.swift
//  Movinder
//
//  Created by Max on 09.03.21.
//

import Foundation

struct Friend {
    var name: String
    let profileimageUrl: String
    let uid: String
    var username: String
    
    init(dictionary: [String: Any]){
        self.name = dictionary["name"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileimageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

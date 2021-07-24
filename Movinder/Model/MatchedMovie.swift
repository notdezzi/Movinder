//
//  MatchedMovie.swift
//  Movinder
//
//  Created by Max on 17.03.21.
//

import Foundation

struct MatchedMovie {
    var name: String
    let profileimageUrl: String
    let uid: String
    
    init(dictionary: [String: Any]){
        self.name = dictionary["name"] as? String ?? ""
        self.profileimageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

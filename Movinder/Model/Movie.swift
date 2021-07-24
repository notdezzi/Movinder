//
//  Movie.swift
//  Movinder
//
//  Created by Max on 03.03.21.
//

import UIKit

struct Movie {
    var name: String
    let length: String
    let rating: String
    let released: String
    let info: String
    let uid: String
    let coverImageUrl: String
    
    init(dictionary: [String: Any]){
        self.name = dictionary["name"] as? String ?? ""
        self.info = dictionary["info"] as? String ?? ""
        self.length = dictionary["length"] as? String ?? ""
        self.rating = dictionary["rating"] as? String ?? ""
        self.released = dictionary["released"] as? String ?? ""
        self.coverImageUrl = dictionary["imageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

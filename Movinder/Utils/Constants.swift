//
//  Constants.swift
//  Movinder
//
//  Created by Max on 27.02.21.
//

import Foundation
import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_MOVIES = Firestore.firestore().collection("movie")
let COLLECTION_SWIPES = Firestore.firestore().collection("swipes")
let COLLECTION_FRIENDS = Firestore.firestore().collection("friends")
let COLLECTION_REQUESTS = Firestore.firestore().collection("requests")
let COLLECTION_MATCHES = Firestore.firestore().collection("matches")

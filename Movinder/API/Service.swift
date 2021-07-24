//
//  Service.swift
//  Movinder
//
//  Created by Max on 27.02.21.
//
import UIKit
import Firebase
struct Service {
    
    
    //MARK: USERS
    static func fetchUser(withUid uid: String, completion: @escaping(User)->Void){
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        
        
        COLLECTION_USERS.getDocuments { ( snapshot, error) in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                guard user.uid != Auth.auth().currentUser?.uid else { return }
                users.append(user)
                if users.count == (snapshot?.documents.count)! - 1 {
                    completion(users)
                }
            })
        }
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    
    
    //MARK: MOVIES
    static func fetchMovie(withUid uid: String, completion: @escaping(Movie)->Void){
        COLLECTION_MOVIES.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let movie = Movie(dictionary: dictionary)
            completion(movie)
        }
    }
    
    static func fetchMovies(completion: @escaping([Movie]) -> Void) {
        var movies = [Movie]()
        fetchSwipes { swipedMovieIDs in
            COLLECTION_MOVIES.getDocuments { ( snapshot, error) in
                snapshot?.documents.forEach({ document in
                    let dictionary = document.data()
                    let movie = Movie(dictionary: dictionary)
                    
                    guard swipedMovieIDs[movie.uid] == nil else { return }
                    
                    movies.append(movie)
//                    if movies.count == snapshot?.documents.count {
//                        completion(movies)
//                    }
                })
                completion(movies)
            }
        }
    }
    
    static func uploadMovieImage(image: UIImage, completion: @escaping(String) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/movieimages/\(filename)")
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    
    
    //MARK: SWIPE
    static func fetchSwipes(completion: @escaping([String: Bool]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_SWIPES.document(uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else {
            completion([String:Bool]())
            return
        }
            
        completion(data)
        }
        
    }
    
    static func saveSwipe(forMovie movie:Movie, isLike: Bool, completion:((Error?) -> Void)?){
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let shouldLike = isLike ? 1:0
        COLLECTION_SWIPES.document(uid).getDocument{( snapshot, error ) in
            let data = [movie.uid: isLike]
            if snapshot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data, completion: completion)
            }else{
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
            if isLike == true {
            let movieData = [ "uid": movie.uid,
                                    "name": movie.name,
                                    "profileImageUrl": movie.coverImageUrl]
        
            COLLECTION_MATCHES.document(uid).collection(uid).document(movie.uid).setData(movieData)
            } else { }
        }
    }
    
    
    //MARK: MATCHES
    static func checkIfMatchExists(forUser friend:Friend,forMovie movie:Movie, completion: @escaping(Bool) -> Void){
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_SWIPES.document(friend.uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else {return}
            guard let didMatch = data[movie.uid] as? Bool else {return}
            completion(didMatch)
        }
    }
    
    static func saveMatchToDatabase(forUser user:User, forFriend friend:Friend, forMovie movie:Movie) {
        
        let movieData = [ "uid": movie.uid,
                                "name": movie.name,
                                "profileImageUrl": movie.coverImageUrl]
    
        COLLECTION_MATCHES.document(user.uid).collection(friend.uid).document(movie.uid).setData(movieData)
        COLLECTION_MATCHES.document(friend.uid).collection(user.uid).document(movie.uid).setData(movieData)
        
    }
    
    static func fetchMatchedMovies(forUser user:User, forFriend friend:Friend, completion: @escaping([MatchedMovie]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_MATCHES.document(uid).collection(friend.uid).getDocuments { (snapshot, error) in
            guard let data = snapshot else { return }
            let matchedMovies = data.documents.map({ MatchedMovie(dictionary: $0.data())})
            completion(matchedMovies)
        }
    }
    
    static func fetchLikedMovies(forUser user: User, completion: @escaping([MatchedMovie]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_MATCHES.document(uid).collection(uid).getDocuments { (snapshot, error) in
            guard let data = snapshot else { return }
            let matchedMovies = data.documents.map({ MatchedMovie(dictionary: $0.data())})
            completion(matchedMovies)
        }
    }
    
    //MARK: Friends
    static func fetchFriends(completion: @escaping([Friend]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FRIENDS.document(uid).collection("friends").getDocuments { (snapshot, error) in
            guard let data = snapshot else { return }
            let friends = data.documents.map({ Friend(dictionary: $0.data())})
            completion(friends)
        }
    }
    
    static func sendFriendRequest(forUser user:User, isAccepted: Bool, completion:((Error?) -> Void)?){
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let shouldLike = isLike ? 1:0
        COLLECTION_REQUESTS.document(uid).getDocument{( snapshot, error ) in
            let data = [user.uid: isAccepted]
            if snapshot?.exists == true {
                COLLECTION_REQUESTS.document(uid).updateData(data, completion: completion)
            }else{
                COLLECTION_REQUESTS.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    
    
    static func addFriendToArray(currentUser:User, matchedUser: User){
            let profileImageUrl = matchedUser.profileImageUrl
            let currentUserProfileImageUrl = currentUser.profileImageUrl
        
            let matchedUserData = [ "uid": matchedUser.uid,
                                    "name": matchedUser.name,
                                    "username": matchedUser.username,
                                    "profileImageUrl": profileImageUrl]
        
            let currentUserData = [ "uid": currentUser.uid,
                                    "name": currentUser.name,
                                    "username": currentUser.username,
                                    "profileImageUrl": currentUserProfileImageUrl]
        
            COLLECTION_FRIENDS.document(currentUser.uid).collection("friends").document(matchedUser.uid).setData(matchedUserData)
            COLLECTION_FRIENDS.document(matchedUser.uid).collection("friends").document(currentUser.uid).setData(currentUserData)
        }
    
    static func friendRequest(forUser user:User, completion: @escaping(Bool) -> Void){
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            COLLECTION_REQUESTS.document(user.uid).getDocument { (snapshot, error) in
                guard let data = snapshot?.data() else {return}
                guard let didMatch = data[currentUid] as? Bool else {return}
                completion(didMatch)
            }
        }
    
    }

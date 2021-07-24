//
//  FriendsController.swift
//  Movinder
//
//  Created by Max on 09.03.21.
//

import UIKit
import Firebase

protocol FriendsControllerDelegate: class {
    func FriendsController(controller: FriendsController, wantsToUpdate user: User)
}


class FriendsController: UICollectionViewController {
    
    private let usercell = UserListCell()
    
    private let user: User
    private var users = [Friend]()
    private var filteredUsers = [Friend]()
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        
        
//      navigationItem.titleView = searchBar
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        collectionView?.register(UserListCell.self, forCellWithReuseIdentifier: UserListCell.cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        
        fetchAllUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }
    
    private func fetchAllUsers() {
        collectionView?.refreshControl?.beginRefreshing()
        Service.fetchFriends { (friends) in
            self.users = friends
            self.filteredUsers = friends
            
            self.collectionView?.reloadData()
            self.collectionView?.refreshControl?.endRefreshing()
        }
        self.collectionView?.refreshControl?.endRefreshing()
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSearch(){
        navigationController?.pushViewController(SearchForFriendsController(), animated: false)
    }
    
    @objc private func handleRefresh() {
        fetchAllUsers()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//                searchBar.resignFirstResponder()
        collectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.pushViewController(ListController(user: user, friend: users[indexPath.item]), animated: true)
//                           let userProfileController = UserProfileController()
//        userProfileController.user = filteredUsers[indexPath.item]
//        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserListCell.cellId, for: indexPath) as! UserListCell
        cell.friend = filteredUsers[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FriendsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}

//MARK: - UISearchBarDelegate
extension FriendsController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

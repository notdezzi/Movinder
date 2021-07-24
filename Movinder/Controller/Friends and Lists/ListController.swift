//
//  ListController.swift
//  Movinder
//
//  Created by Max on 17.03.21.
//

import UIKit

protocol ListControllerDelegate: class {
    func ListController(controller: ListController, wantsToUpdate movie: Movie)
}

class ListController: UICollectionViewController {
    
//MARK: Properties
    
    private let user: User
    private var users = [User]()
    private var filteredUsers = [User]()
    
    private let friend: Friend
    
    private var movie: MatchedMovie?
    private var movies = [MatchedMovie]()
    private var filteredMovies = [MatchedMovie]()
    
    var currentUser: User?
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search for specific Movie"
        sb.autocorrectionType = .no
        sb.autocapitalizationType = .none
        sb.barTintColor = .gray
        return sb
    }()
    
//MARK: Lifecycle
    
    init(user: User, friend: Friend) {
        self.user = user
        self.friend = friend
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }

//MARK: Helpers

    func configureUI() {
        navigationItem.titleView = searchBar
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        collectionView?.register(MovieListCell.self, forCellWithReuseIdentifier: MovieListCell.cellId)
        let refreshControl = UIRefreshControl()
        //        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        collectionView.delegate = self
        searchBar.delegate = self
        fetchAllMovies()
    }
   
    private func fetchAllMovies() {
        collectionView?.refreshControl?.beginRefreshing()
        Service.fetchMatchedMovies(forUser: user, forFriend: friend) { (movies) in
            self.movies = movies
            self.filteredMovies = movies
            self.searchBar.text = ""
            self.collectionView?.reloadData()
            self.collectionView?.refreshControl?.endRefreshing()
        }
        self.collectionView?.refreshControl?.endRefreshing()
    }
    
    //MARK: Functions
    
    @objc func handleSearch() {
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        //                   let userProfileController = UserProfileController()
        //                   userProfileController.user = filteredUsers[indexPath.item]
        //                   navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCell.cellId, for: indexPath) as! MovieListCell
        cell.movie = filteredMovies[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}

//MARK: - UISearchBarDelegate

extension ListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { (movie) -> Bool in
                return movie.name.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

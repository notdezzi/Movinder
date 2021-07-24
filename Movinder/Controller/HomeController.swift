//
//  HomeController.swift
//  Movinder
//
//  Created by Max on 25.02.21.
//

import UIKit
import Firebase


class HomeController: UIViewController {
    
    //MARK: Properties
    
    private var user: User?
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    private var viewModels = [CardViewModel](){
        didSet { configureCards() }
    }
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureUI()
        fetchUser()
        fetchMovies()
    }
    
    //MARK: API
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func fetchMovies(){
        Service.fetchMovies{ movies in
            self.viewModels = movies.map({ CardViewModel(movie: $0) })
        }
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser ==  nil {
            presentLoginController()
        } else {
        }
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            presentLoginController()
        }catch{
            print("DEBUG: Failed to Sign Out!")
        }
    }
    
    func saveSwipeAndCheckForMatch(forMovie movie:Movie, didLike: Bool){
        Service.saveSwipe(forMovie: movie, isLike: didLike) { error in
            Service.fetchFriends { (friends) in
                friends.forEach { (friends) in
                    self.topCardView = self.cardViews.last
                    guard didLike == true else {return}
                    Service.checkIfMatchExists(forUser: friends, forMovie: movie) { didMatch in
                        guard let currentUser = self.user else {return}
                        Service.saveMatchToDatabase(forUser: currentUser, forFriend: friends, forMovie: movie)
                    }
                }
            }
        }
    }
    
    //MARK: Helpers
    
    func configureCards(){
        viewModels.prefix(10).forEach{ viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        cardViews = deckView.subviews.map({ ($0 as? CardView)!})
        topCardView = cardViews.last
    }
    
    func configureUI(){
        view.backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [topStack,deckView,bottomStack])
        topStack.delegate = self
        bottomStack.delegate = self
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom:0 , right: 12)
        stack.bringSubviewToFront(deckView)
    }
    
    func presentLoginController(){
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func performSwipeAnimation(shouldLike: Bool){
        let translation: CGFloat = shouldLike ? -700 : 700
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.topCardView?.frame = CGRect(x: translation, y: 0,
                                             width: (self.topCardView?.frame.width)!,
                                             height: (self.topCardView?.frame.height)!)
        }) {_ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
    
    
}
//MARK: EXTENSION - HomeNavigationStackViewDelegate
extension HomeController: HomeNavigationStackViewDelegate {
    func showSettings() {
        guard let user = self.user else { return }
        let controller = SettingsController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    func showMessages() {
        guard let user = self.user else { return }
        let controller = FriendsController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

//MARK: EXTENSION - CardViewDelegate

extension HomeController: CardViewDelegate {
    func cardView(_ view: CardView, didLikeMovie: Bool) {
        view.removeFromSuperview()
        self.cardViews.removeAll(where: {view == $0})
        guard let movie = topCardView?.viewModel.movie else { return }
        saveSwipeAndCheckForMatch(forMovie: movie, didLike: didLikeMovie)
        self.topCardView = cardViews.last
    }
    func cardView(_ view: CardView, wantsToShowProfileFor movie:Movie){
        let controller = ProfileController(movie: movie)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
        controller.delegate = self
    }
}

//MARK: EXTENSION - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    func handleShowLiked() {
        guard let user = self.user else { return }
        let controller = LikedListController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleLike() {
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forMovie: topCard.viewModel.movie, didLike: true)
        print("Liked movie: \(topCard.viewModel.movie.name)")
    }
    func handleDislike() {
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: false)
        Service.saveSwipe(forMovie: topCard.viewModel.movie, isLike: false, completion: nil)
        print("Disliked movie: \(topCard.viewModel.movie.name)")
    }
    func handleRefresh() {
        self.fetchMovies()
    }
}

//MARK: EXTENSION - ProfileControllerDelegate

extension HomeController: ProfileControllerDelegate {
    func profileController(_ controller: ProfileController, didLikeMovie movie: Movie) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forMovie: movie, didLike: true)
        }
    }
    func profileController(_ controller: ProfileController, didDislikeMovie movie: Movie) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: false)
            self.saveSwipeAndCheckForMatch(forMovie: movie, didLike: false)
        }
    }
}

//MARK: SettingsControllerDelgate

extension HomeController: SettingsControllerDelegate {
    func settingsControllerWantsToLogOut(_ controller: SettingsController) {
        controller.delegate = self
        controller.dismiss(animated: true, completion: nil)
        logout()
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
    }
}

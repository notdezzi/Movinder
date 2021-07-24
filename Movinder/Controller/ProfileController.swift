//
//  ProfileController.swift
//  Movinder
//
//  Created by Max on 06.03.21.
//
import UIKit
import SDWebImage
protocol ProfileControllerDelegate: class {
    func profileController(_ controller: ProfileController, didLikeMovie movie: Movie)
    func profileController(_ controller: ProfileController, didDislikeMovie movie: Movie)
}

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let movie: Movie
    
    weak var delegate: ProfileControllerDelegate?
    
    var imageicon: UIImage?
    
    private lazy var imageView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        let v = UIView(frame: frame)
        v.backgroundColor = .systemGroupedBackground
        let imageView = UIImageView(frame: frame)
        let imageUrl = URL(string: movie.coverImageUrl)
        let loaded = false
        if loaded == false {
            if imageicon == nil {
                imageicon = #imageLiteral(resourceName: "photo_placeholder")
            }
        }else{
        }
        SDWebImageManager.shared().loadImage(with: imageUrl, options: .continueInBackground, progress: nil){
            (image, _,_,_,_,_) in
            self.imageicon = image
        }
        imageView.image = imageicon
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let dissmissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    //MARK: LABELS
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24,weight: .semibold)
        return label
    }()
    private let infoLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    private let lengthLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    private let ratingLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    private let releasedLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    //MARK: BUTTONS
    private lazy var likeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "like_circle"))
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    private lazy var dislikeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "dismiss_circle"))
        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        return button
    }()
    //MARK: Lifecycle
    init(movie: Movie){
        self.movie = movie
        self.movieNameText = movie.name
        self.movieInfoText = movie.info
        self.movieLengthText = movie.length
        self.movieRatingText = movie.rating
        self.movieReleasedText = movie.released
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: Helpers
    let movieNameText : String
    let movieInfoText : String
    let movieLengthText : String
    let movieRatingText : String
    let movieReleasedText : String
    func configureUI(){
        let infoStack = UIStackView(arrangedSubviews: [nameLabel,infoLabel,lengthLabel,ratingLabel,releasedLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        view.addSubview(tableView)
        view.addSubview(infoStack)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        let headerView = StrechyHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250))
        
        let imageUrl = URL(string: movie.coverImageUrl)
        SDWebImageManager.shared().loadImage(with: imageUrl, options: .continueInBackground, progress: nil){
            (image, _,_,_,_,_) in
            self.imageicon = image
        }
        headerView.imageView.image = imageicon
        tableView.separatorStyle = .none
        
        self.tableView.tableHeaderView = headerView
        view.backgroundColor = .white
        view.addSubview(dissmissButton)
        dissmissButton.setDimensions(height: 40, width: 40)
        dissmissButton.anchor(top: headerView.bottomAnchor,right: view.rightAnchor, paddingTop: -20 , paddingRight: 16)
        nameLabel.text = "" + movieNameText
        lengthLabel.text = "Length: " + movieLengthText
        infoLabel.text = "Info: \n" + movieInfoText
        ratingLabel.text = "Rating: " + movieRatingText
        releasedLabel.text = "Released in: " + movieReleasedText
        infoStack.isUserInteractionEnabled = true
        infoStack.anchor(top: headerView.bottomAnchor , left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12,paddingRight: 12)
        configureBottomControls()
    }
    
    func configureBottomControls(){
        let stack = UIStackView(arrangedSubviews: [likeButton,dislikeButton])
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.spacing = -32
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
    }
    
    func createButton(withImage image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    //MARK: Fuctions
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLike(){
        delegate?.profileController(self, didLikeMovie: movie)
    }
    
    @objc func handleDislike(){
        delegate?.profileController(self, didDislikeMovie: movie)
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
}
extension ProfileController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! StrechyHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}

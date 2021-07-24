//
//  CardView.swift
//  Movinder
//
//  Created by Max on 26.02.21.
//

import UIKit
import SDWebImage

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

protocol CardViewDelegate: class {
    func cardView(_ view: CardView, wantsToShowProfileFor movie: Movie)
    func cardView(_ view: CardView, didLikeMovie: Bool)
}

class CardView: UIView{
    
    //MARK: Properties
    
    weak var delegate: CardViewDelegate?
    
    let viewModel: CardViewModel
    
    private let gradientLayer = CAGradientLayer()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    init(viewModel: CardViewModel){
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureGestureRecognizers()
        imageView.sd_setImage(with: viewModel.imageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.fillSuperview()
        configureGradientLayer()
        addSubview(infoLabel)
        infoLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16,paddingBottom: 16, paddingRight: 16)
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)
        
        
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    
    @objc func handleShowProfile(){
        delegate?.cardView(self, wantsToShowProfileFor: viewModel.movie)
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        switch sender.state{
        case .began:
            superview?.subviews.forEach({ $0.layer.removeAllAnimations() })
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }
    
    @objc func handleChangePhoto(sender: UITapGestureRecognizer){
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        if shouldShowNextPhoto {
            viewModel.showNextPhoto()
        }else{
            viewModel.showPreviousPhoto()
        }
        //        imageView.image = viewModel.imageToShow
    }
    
    
    //MARK: HELPERS
    
    func panCard(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x:translation.x, y: translation.y)
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer){
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 100
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                        if shouldDismissCard{
                            let xTranslation = CGFloat(direction.rawValue) * 1000
                            let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                            self.transform = offScreenTransform
                        }else {
                            self.transform = .identity
                        }})
        if shouldDismissCard{
            let didLike = direction == .left
            self.delegate?.cardView(self, didLikeMovie: didLike)
        }
    }
    
    func configureGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizers(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
}

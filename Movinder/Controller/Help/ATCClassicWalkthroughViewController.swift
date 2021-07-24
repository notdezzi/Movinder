//
//  ATCClassicWalkthroughViewController.swift
//  Movinder
//
//  Created by Max on 22.03.21.
//
import UIKit

class ATCClassicWalkthroughViewController: UIViewController {
  @IBOutlet var containerView: UIView!
  @IBOutlet var imageContainerView: UIView!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var subtitleLabel: UILabel!
  
  let model: ATCWalkthroughModel
  
  init(model: ATCWalkthroughModel,
       nibName nibNameOrNil: String?,
       bundle nibBundleOrNil: Bundle?) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    imageView.image = #imageLiteral(resourceName: "lady5c")
//    imageView.contentMode = .scaleAspectFill
//    imageView.clipsToBounds = true
//    imageView.tintColor = .white
//    imageContainerView.backgroundColor = .clear
    
//    titleLabel.text = model.title
//    titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//    titleLabel.textColor = .white
//
//    subtitleLabel.attributedText = NSAttributedString(string: model.subtitle)
//    subtitleLabel.font = UIFont.systemFont(ofSize: 14.0)
//    subtitleLabel.textColor = .white
    
//    containerView.backgroundColor = UIColor(hexString: "#3068CC")
  }
}

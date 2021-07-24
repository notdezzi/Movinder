//
//  EditProfileController.swift
//  Movinder
//
//  Created by Max on 21.03.21.
//

import UIKit

class EditProfileController: UITableViewController {
    
    //MARK: Properties
    private let user: User
    
    private lazy var headerView = SettingsHeaderView(user: user)
    private let imagePicker = UIImagePickerController()
    
    weak var delegate: SettingsControllerDelegate?
    
    
    //MARK: Lifecycle
    
    
    init(user:User){
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        configureUI()
    }
    
    //MARK: Actions
    
    @objc func handleDone(){
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helpers
    
    func setHeaderImage( image: UIImage ){
        headerView.button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func configureUI(){
        headerView.delegate = self
        imagePicker.delegate = self
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDone))
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
    }
}
extension EditProfileController: SettingsHeaderViewDelegate {
    func settingsHeaderView(header: SettingsHeaderView, didSelect index: Int) {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        
        setHeaderImage(image: selectedImage!)
        
        dismiss(animated: true, completion: nil)
    }
}



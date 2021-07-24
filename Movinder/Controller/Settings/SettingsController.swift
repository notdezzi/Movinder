//
//  SettingsController.swift
//  Movinder
//
//  Created by Max on 03.03.21.
//
import UIKit
import SDWebImage
import FirebaseAuth

struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case userCell(model: SettingsOption)
}

struct UserSettingsOption {
    let title: String
    let icon: UIImage?
    let iconbackgroundcolor: UIColor
    let handler: (() -> Void)
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconbackgroundcolor: UIColor
    let handler: (() -> Void)
}

protocol SettingsControllerDelegate: class {
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User)
    func settingsControllerWantsToLogOut(_ controller: SettingsController)
}

class SettingsController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    //MARK: Properties
    
    weak var delegate: SettingsControllerDelegate?
    private let tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        return table
    }()
    var imageUrl: URL?
    var models = [Section]()
    private let footerView = SettingsFooter()
    var userInfoHeader: UserInfoHeader!
    var imageicon: UIImage?
    
    var vc = UITableViewController(style: .plain)
    
    //MARK: Lifecycle
    
    private let user: User
    
    init(user:User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame, user: self.user)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
        configureUI()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureUI(){
        
        userInfoHeader.profileImageView.image = imageicon
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDone))
        models.append(Section(title: "Edit Profile",
                              options: [
                                .staticCell(model: SettingsOption(title: "Edit Profile", icon: UIImage(systemName: "person.fill"), iconbackgroundcolor: .systemBlue){ self.handleUserSettings() })]))
        models.append(Section(title: "Help",
                              options: [
                                .staticCell(model: SettingsOption(title: "Notifications", icon: UIImage(systemName: "bell.fill"), iconbackgroundcolor: .systemRed){ self.handleNotifications() }),
                                .staticCell(model: SettingsOption(title: "Help", icon: UIImage(systemName: "info"), iconbackgroundcolor: .systemBlue){ self.handleHelp() }),
                                .staticCell(model: SettingsOption(title: "Tell a Friend", icon: UIImage(systemName: "heart.fill"), iconbackgroundcolor: .systemPink){ self.shareButtonClicked(sender: self) })]))
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        footerView.delegate = self
    }
    
    //MARK: Actions
    
    @objc func handleHelp(){
        navigationController?.pushViewController(HelpController(), animated: true)
    }
    
    @objc func handleUserSettings(){
        navigationController?.pushViewController(EditProfileController(user:user), animated: true)
    }
    
    @objc func handleDone(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNotifications(){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func shareButtonClicked(sender: AnyObject)
    {
        let message = "Hey,\nMovinder is a fast and simple way to find movies to watch with your Partner or Friends.\nCheck it out!\n\n"
        if let link = NSURL(string: "http://movinder.com/download")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    //MARK: HELPERS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    //MARK: TABLEVIEW
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        let section = models[section]
    //        return section.title
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        switch model.self{
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier,
                                                           for: indexPath) as? SettingsCell else {
                return UITableViewCell()
            }
            cell.configureUI(with: model)
            return cell
        case .userCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier,
                                                           for: indexPath) as? SettingsCell else {
                return UITableViewCell()
            }
            cell.configureUI(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        switch model.self{
        case .staticCell(let model):
            model.handler()
        case .userCell(let model):
            model.handler()
        }
    }
}

extension SettingsController: SettingsFooterDelegate {
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }catch{
            print("DEBUG: Failed to Sign Out!")
        }
    }
}



//class SettingsController: UITableViewController{
//
//    //MARK: Properties
//    private let user: User
//
//    private lazy var headerView = SettingsHeaderView(user: user)
//    private let imagePicker = UIImagePickerController()
//
//    weak var delegate: SettingsControllerDelegate?
//
//    //MARK: Lifecycle
//
//
//    init(user:User){
//        self.user = user
//        super.init(style: .plain)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureUI()
//    }
//
//    //MARK: Actions
//
//    @objc func handleCancel(){
//        dismiss(animated: true, completion: nil)
//    }
//
//    @objc func handleDone(){
//        dismiss(animated: true, completion: nil)
//        print("DEBUG: Pressed Done")
//    }
//
//
//    //MARK: Helpers
//
//    func setHeaderImage( image: UIImage ){
//        headerView.button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
//    }
//
//    func configureUI(){
//        headerView.delegate = self
//        imagePicker.delegate = self
//
//        navigationItem.title = "Settings"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.tintColor = .black
//
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
//        tableView.separatorStyle = .none
//
//        tableView.tableHeaderView = headerView
//        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//
//    }
//}
//extension SettingsController: SettingsHeaderViewDelegate {
//    func settingsHeaderView(header: SettingsHeaderView, didSelect index: Int) {
//        present(imagePicker, animated: true, completion: nil)
//    }
//}
//
//extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let selectedImage = info[.originalImage] as? UIImage
//
//        setHeaderImage(image: selectedImage!)
//
//        dismiss(animated: true, completion: nil)
//    }
//}

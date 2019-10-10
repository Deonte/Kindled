//
//  SettingsController.swift
//  Kindled
//
//  Created by Deonte on 10/9/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import JGProgressHUD

protocol SettingsControllerDelegate {
    func didSaveSettings()
}


class SettingsController: UITableViewController {
    
    var user: User?
    
    var delegate: SettingsControllerDelegate?
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupTableView()
        fetchCurrentUser()
    }
    
    // MARK: - Methods
    @objc func handleSelectPhoto(button: UIButton) {
        print("Selecting Photo with button", button)
        let imagePickerController = CustomImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageButton = button
        present(imagePickerController, animated: true)
    }
    
    @objc func handleSave() {
        
        print("saving our setting to the firestore")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String : Any] = [
            "uid" : uid ,
            "fullName" : user?.name ?? "",
            "imageUrl1" : user?.imageUrl1 ?? "",
            "imageUrl2" : user?.imageUrl2 ?? "",
            "imageUrl3" : user?.imageUrl3 ?? "",
            "age" : user?.age ?? -1,
            "profession" : user?.profession ?? "",
            "minSeekingAge" : user?.minSeekingAge ?? -1,
            "maxSeekingAge" : user?.maxSeekingAge ?? -1
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user settings:", err)
                return
            }
            
            print("Finished saving user info")
            self.dismiss(animated: true) {
                print("Dismissal Complete")
                self.delegate?.didSaveSettings()
                //HomeController.fetchCurrentUser() // Refetch cards inside homeController
            }
        }
        
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    
    // MARK: - Networking Firebase
    
    fileprivate func fetchCurrentUser() {
        // Fetch the current user
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("user").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            
            // Fetched our user data
            //print(snapshot?.data())
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.loadUserPhotos()
            
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        if  let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _,_, _, _) in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if  let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _,_, _, _) in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if  let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _,_, _, _) in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
    }
    
    
    // MARK: Setup TableView
    fileprivate func setupTableView() {
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
    
    
    lazy var header:UIView = {
        
        let header = UIView()
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            image2Button,
            image3Button
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        return header
    }()
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
            headerLabel.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        return headerLabel
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 300
        }
        
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.minLabel.text = "Min: \(Int(slider.value))"
        
        self.user?.minSeekingAge = Int(slider.value)

    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.maxLabel.text = "Max: \(Int(slider.value))"
        
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            
            // Setup Labels
            ageRangeCell.minLabel.text = "Min: \(user?.minSeekingAge ?? -1)"
            ageRangeCell.maxLabel.text = "Max: \(user?.maxSeekingAge ?? -1)"
            return ageRangeCell
        }
        
        switch indexPath.section {
        case 1:
            cell.textFeild.placeholder = "Enter Name"
            cell.textFeild.text = user?.name
            cell.textFeild.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textFeild.placeholder = "Enter Profession"
            cell.textFeild.text = user?.profession
            cell.textFeild.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
            
        case 3:
            cell.textFeild.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textFeild.placeholder = String(age)
            }
            cell.textFeild.keyboardType = .numberPad
            cell.textFeild.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)

        default:
            cell.textFeild.placeholder = "Enter Bio"
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 1
    }
    
    
    // MARK:- Setup NavigationControls
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        ]
    }
    
}


// MARK:- Extension

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}


class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}


extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
        // How do I set the image to my button
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading images.."
        hud.show(in: view)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            
            hud.dismiss()
            if let err = err {
                print("Failed to upload to storage:", err)
                return
            }
            
            print("Finished uploading image.")
            ref.downloadURL { (url, err) in
                if let err = err {
                    print("Failed to retrieve DownloadUrl:", err)
                }
                
                print("Finished getting download url:", url?.absoluteString ?? "")
                
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
                
            }
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}



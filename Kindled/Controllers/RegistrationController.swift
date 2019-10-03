//
//  RegistrationController.swift
//  Kindled
//
//  Created by Deonte on 10/1/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.widthAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.attributedPlaceholder = NSAttributedString(string: "Enter full name",
                                                      attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular),
                                                                   NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.backgroundColor = .white
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.attributedPlaceholder = NSAttributedString(string: "Enter email",
                                                      attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular),
                                                                   NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.attributedPlaceholder = NSAttributedString(string: "Enter password",
                                                      attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular),
                                                                   NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    @objc fileprivate func handleTextChange(textfield: UITextField) {
        
        if textfield == fullNameTextField {
            print("Full name Changing:", textfield.text ?? "")
            registrationViewModel.fullName = textfield.text
        } else if textfield == emailTextField {
            print("Email Changing:", textfield.text ?? "")
            registrationViewModel.email = textfield.text
        } else {
            print("Password Changing:", textfield.text ?? "")
            registrationViewModel.password = textfield.text
        }
        //
        //        let isFormValid = fullNameTextField.text?.isEmpty == false && emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        //        registerButton.isEnabled = isFormValid
        //
        //        if isFormValid {
        //            registerButton.backgroundColor = #colorLiteral(red: 0.8197038174, green: 0.09510942549, blue: 0.3320324421, alpha: 1)
        //        } else {
        //            registerButton.backgroundColor = .lightGray
        //        }
        //
    }
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupNotificationsObservers()
        setupTapGesture()
        setupRegistrationViewModelObsever()
        // MARK: Just a way back to the home screen. NOT FINAL
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
    
    
    
    // MARK: - Private
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObsever() {
        registrationViewModel.isFormValidObserver = { (isFormValid) in
            print("Form is changing, is it valid?", isFormValid)
            if isFormValid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8197038174, green: 0.09510942549, blue: 0.3320324421, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.backgroundColor = .lightGray
                self.registerButton.setTitleColor(.gray, for: .disabled)
            }
        }
    }
    
    
    @objc func handleRegister() {
        print("Register Tapped")
        let homeController = HomeController()
        homeController.modalPresentationStyle = .fullScreen
        present(homeController, animated: true)
        self.removeFromParent()
    }
    
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        // How to configure how tall the keyboard is
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        // How tall is the gap is from the register button to the bottom of the screen.
        
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        print(bottomSpace)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // If not done will have a retain cycle
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        
        let topColor = #colorLiteral(red: 0.9885410666, green: 0.362270385, blue: 0.3780726194, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8985644579, green: 0.1132306531, blue: 0.4665623307, alpha: 1)
        gradientLayer.frame = view.frame
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
        ])
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
    ])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    fileprivate func setupLayout() {
        setupGradientLayer()
        
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}

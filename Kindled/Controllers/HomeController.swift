//
//  HomeController.swift
//  Kindled
//
//  Created by Deonte on 9/25/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate {
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]() // Empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        fetchCurrentUser()
        //setupFirestoreUserCards()
        //fetchUsersFromFirestore()
        
    }
    
    
    
    //MARK:- Setup BottomControls
    
    fileprivate var user: User?
    
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
           // print("current User:", self.user)
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    

    
    //MARK:- Setup Layout Home Screen
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else {
            return
        }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        // Introducing pagination here and filtering only 3 users at a time
        //let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age" , isLessThanOrEqualTo: maxAge)
        
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            })
        
            //self.setupFirestoreUserCards()
        }

    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    @objc func handleSettings() {
        print("Settings Tapped")
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
        //self.removeFromParent()
    }
    
    func didSaveSettings() {
        print("Notify of dismissal of SettingsController in the HomeController")
        fetchCurrentUser()
    }
    
    @objc func handleLogin() {
        print("Settings Tapped")
        let settingsController = RegistrationController()
        present(settingsController, animated: true)
        //self.removeFromParent()
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
     
        let parentStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        parentStackView.axis = .vertical
        
        view.addSubview(parentStackView)
        parentStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        parentStackView.isLayoutMarginsRelativeArrangement = true
        parentStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        parentStackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func setupFirestoreUserCards() {
        
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}


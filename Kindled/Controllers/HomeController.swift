//
//  HomeController.swift
//  Kindled
//
//  Created by Deonte on 9/25/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]() // Empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
    }
    
    //MARK:- Setup Layout Home Screen
    
    fileprivate func fetchUsersFromFirestore() {
        
        let query = Firestore.firestore().collection("users")
        //let query = Firestore.firestore().collection("users").whereField("friends", arrayContains: "Kendra")
       
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                print("Cards showing up:", user.name)
                self.setupFirestoreUserCards()
            })
        }
    }
    
    @objc func handleSettings() {
        print("Settings Tapped")
        let registrationController = RegistrationController()
        registrationController.modalPresentationStyle = .fullScreen
        present(registrationController, animated: true)
        self.removeFromParent()
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
     
        let parentStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
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


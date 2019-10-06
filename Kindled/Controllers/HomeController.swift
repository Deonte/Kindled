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

//    let cardViewModels: [CardViewModel] = {
//        let producers = [
//            Advertiser(title: "Code with us live", brandName: "The Code Brothers", posterPhotoName: "coding"),
//            User(name: "Megan", age: 25, profession: "Photographer", imageNames: ["woman1", "woman1-2"]),
//            Advertiser(title: "I'm here so I don't get fined.", brandName: "Marshawn Lynch", posterPhotoName: "ML"),
//            User(name: "Jessica", age: 22, profession: "Model", imageNames: ["woman2"]),
//            Advertiser(title: "Ready for a Run?", brandName: "Learn to Run", posterPhotoName: "ltrAD"),
//            User(name: "Brittany", age: 29, profession: "Web Developer", imageNames: ["woman3", "woman3-2", "woman3-3"]),
//            User(name: "Jessica", age: 31, profession: "Real Estate Broker", imageNames: ["lady4c"])
//        ] as [ProducesCardViewModel]
//
//        let viewModels = producers.map({return $0.toCardViewModel()})
//        return viewModels
//    }()
    
    var cardViewModels = [CardViewModel]() // Empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupDummyCards()
        fetchUsersFromFirestore()
    }
    
    //MARK:- Setup Layout Home Screen
    
    fileprivate func fetchUsersFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
               // print(user.name, user.imageNames)
                self.setupDummyCards()
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
    
    fileprivate func setupDummyCards() {
        
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}


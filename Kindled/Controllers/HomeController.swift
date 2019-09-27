//
//  HomeController.swift
//  Kindled
//
//  Created by Deonte on 9/25/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()

//    let users = [
//        User(name: "Megan", age: 25, profession: "Photographer", imageName: "woman1"),
//        User(name: "Jessica", age: 22, profession: "Model", imageName: "woman2"),
//        User(name: "Brittany", age: 29, profession: "Web Developer", imageName: "woman3"),
//        User(name: "Jessica", age: 31, profession: "Real Estate Broker", imageName: "lady4c")
//    ]
    
    let cardViewModels = [
        User(name: "Megan", age: 25, profession: "Photographer", imageName: "woman1").toCardViewModel(),
        User(name: "Jessica", age: 22, profession: "Model", imageName: "woman2").toCardViewModel(),
        User(name: "Brittany", age: 29, profession: "Web Developer", imageName: "woman3").toCardViewModel(),
        User(name: "Jessica", age: 31, profession: "Real Estate Broker", imageName: "lady4c").toCardViewModel()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
        
    }
    
    //MARK:- Setup Layout Home Screen
    
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
            cardView.imageView.image = UIImage(named: cardVM.imageName)
            cardView.informationLabel.attributedText = cardVM.attributedString
            cardView.informationLabel.textAlignment = cardVM.textAlignment
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
//        users.forEach { (user) in
//            let cardView = CardView(frame: .zero)
//            cardView.imageView.image = UIImage(named: user.imageName)
//            cardView.informationLabel.text = "\(user.name) \(user.age)\n\(user.profession)"
//
//            let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
//            attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
//            attributedText.append(NSAttributedString(string: "\n\(user.profession)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
//
//            cardView.informationLabel.attributedText = attributedText
//
//
//            cardsDeckView.addSubview(cardView)
//            cardView.fillSuperview()
//        }
    }
}


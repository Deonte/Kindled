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

    let cardViewModels: [CardViewModel] = {
        let producers = [
            Advertiser(title: "Code with us live", brandName: "The Code Brothers", posterPhotoName: "coding"),
            User(name: "Megan", age: 25, profession: "Photographer", imageName: "woman1"),
            Advertiser(title: "I'm here so I don't get fined.", brandName: "Marshawn Lynch", posterPhotoName: "ML"),
            User(name: "Jessica", age: 22, profession: "Model", imageName: "woman2"),
            Advertiser(title: "Ready for a Run?", brandName: "Learn to Run", posterPhotoName: "ltrAD"),
            User(name: "Brittany", age: 29, profession: "Web Developer", imageName: "woman3"),
            User(name: "Jessica", age: 31, profession: "Real Estate Broker", imageName: "lady4c")
        ] as [ProducesCardViewModel]
        
        let viewModels = producers.map({return $0.toCardViewModel()})
        return viewModels
    }()
    
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
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}


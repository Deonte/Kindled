//
//  ViewController.swift
//  Kindled
//
//  Created by Deonte on 9/25/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
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
        print("Setting up dummy cards")
        let cardView = CardView(frame: .zero)
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
}


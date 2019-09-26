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
    let blueView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    //MARK:- FilePrivate
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        blueView.backgroundColor = .blue
        
        let parentStackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottomStackView])
        parentStackView.axis = .vertical
        
        view.addSubview(parentStackView)
        parentStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
    }
}


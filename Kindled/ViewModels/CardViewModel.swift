//
//  CardViewModel.swift
//  Kindled
//
//  Created by Deonte on 9/27/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit

// Protocol Oriented Programming
protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

// View model is supposed to represent the state of the view
class CardViewModel {
    // Define the properties that the view will display or render out
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image ?? UIImage())
        }
    }
    
    // Reactive Programming
    var imageIndexObserver: ((Int, UIImage) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}

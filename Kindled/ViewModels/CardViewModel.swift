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

struct CardViewModel {
    // Define the properties that the view will display or render out
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}

// What do we do with the card view model

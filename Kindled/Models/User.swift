//
//  User.swift
//  Kindled
//
//  Created by Deonte on 9/27/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    var name: String?
    var age: Int?
    var profession: String?
//    let imageNames: [String]
    var imageUrl1: String?
    var uid: String?
    
    init(dictionary: [String : Any]) {
        // We will init our user here
       
        self.profession = dictionary["profession"] as? String
        self.age = dictionary["age"] as? Int
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
//        self.imageNames = [imageUrl1]
        
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        let professionString = profession != nil ? profession! : "Not available"
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}

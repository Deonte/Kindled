//
//  RegistrationViewModel.swift
//  Kindled
//
//  Created by Deonte on 10/3/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
    
    //var image: UIImage? { didSet { imageObserver?(image)} }
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity()} }
    var password: String? { didSet { checkFormValidity()} }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
       // isFormValidObserver?(isFormValid)
    }
    
    var bindableIsFormValid = Bindable<Bool>()
    
    // Reactive Programming
   // var isFormValidObserver: ((Bool) -> ())?
   // var imageObserver: ((UIImage?) -> ())?
}

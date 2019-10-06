//
//  RegistrationViewModel.swift
//  Kindled
//
//  Created by Deonte on 10/3/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity()} }
    var password: String? { didSet { checkFormValidity()} }
    
    func performRegistration(completion:@escaping (Error?) -> ()) {
        bindableIsRegistering.value = true
        guard let email = email, let password = password else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            
            if let error = error {
                print(error)
                completion(error)
                return
            }
            print("Successfully registured user:", res?.user.uid ?? "")
            
            // You can only upload to Firebase storage once you are authorized.
            let filename = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/images/\(filename)")
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            ref.putData(imageData, metadata: nil) { (_, err) in
                
                if let err = err {
                    completion(err)
                    return // Bail
                }
                
                print("Finished uploading image to storage.")
                
                ref.downloadURL { (url, err) in
                    if let err = err {
                        completion(err)
                        return
                    }
                    self.bindableIsRegistering.value = false
                    print("Download url of our image is:", url?.absoluteString ?? "")
                    // Store the download url in firestore
                }
            }
            
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
   
}

//
//  Bindable.swift
//  Kindled
//
//  Created by Deonte on 10/5/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}

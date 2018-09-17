//
//  Box.swift
//  FactoryWeather
//
//  Created by Matej Korman on 03/09/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    var listeners = [Listener]()
    
    var value: T {
        didSet { listeners.forEach({ $0(value) }) }
    }
    
    init(_ value: T) {
        self.value = value
    }
}

extension Box {
    func bind(_ listener: @escaping Listener) {
        self.listeners.append(listener)
    }
    
    func bindAndFire(_ listener: @escaping Listener) {
        self.listeners.append(listener)
        listener(value)
    }
}

//
//  Conditions.swift
//  FactoryWeather
//
//  Created by Matej Korman on 22/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct Conditions: OptionSet {
    let rawValue: Int
    
    static let humidity = Conditions(rawValue: 1)
    static let windSpeed = Conditions(rawValue: 2)
    static let pressure = Conditions(rawValue: 4)
    
    static let all: Conditions = [.humidity, .windSpeed, .pressure]
    
    mutating func toggle(condition: Conditions) {
        if self.contains(condition) {
            self.remove(condition)
        } else {
            self.insert(condition)
        }
    }
}

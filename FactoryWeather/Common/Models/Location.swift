//
//  Location.swift
//  FactoryWeather
//
//  Created by Matej Korman on 17/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct Location {
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    var fullName: String {
        return name + ", " + country
    }
}

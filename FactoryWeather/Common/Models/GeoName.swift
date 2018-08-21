//
//  GeoName.swift
//  FactoryWeather
//
//  Created by Matej Korman on 20/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct GeoName: Codable {
    let locations: [Location]
    
    private enum CodingKeys: String, CodingKey {
        case locations = "geonames"
    }
}

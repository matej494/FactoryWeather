//
//  Location.swift
//  FactoryWeather
//
//  Created by Matej Korman on 17/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct Location: Codable {
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    var fullName: String {
        return name + ", " + country
    }
    
    init(name: String, country: String, latitude: Double, longitude: Double) {
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.country = try container.decode(String.self, forKey: .country)
        self.longitude = try Double(container.decode(String.self, forKey: .longitude)) ?? -1
        self.latitude = try Double(container.decode(String.self, forKey: .latitude)) ?? -1
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case country = "countryCode"
        case latitude = "lat"
        case longitude = "lng"
    }
}

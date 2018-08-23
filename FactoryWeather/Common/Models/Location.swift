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
    
    private enum CodingKeys: String, CodingKey {
        case name
        case country = "countryCode"
        case latitude = "lat"
        case longitude = "lng"
    }
}

extension Location {
    init(realmLocation: RealmLocation) {
        self.name = realmLocation.name
        self.country = realmLocation.country
        self.latitude = realmLocation.latitude
        self.longitude = realmLocation.longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.country = try container.decode(String.self, forKey: .country)
        self.longitude = try Double(container.decode(String.self, forKey: .longitude)) ?? -1
        self.latitude = try Double(container.decode(String.self, forKey: .latitude)) ?? -1
    }
}

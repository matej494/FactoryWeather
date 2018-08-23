//
//  RealmLocation.swift
//  FactoryWeather
//
//  Created by Matej Korman on 23/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation
import RealmSwift

class RealmLocation: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var latitude: Double = -1
    @objc dynamic var longitude: Double = -1
    
    convenience init(location: Location) {
        self.init()
        self.name = location.name
        self.country = location.country
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
}

extension RealmLocation {
    func compare(with location: Location) -> Bool {
        return latitude == location.latitude && longitude == location.longitude
    }
}

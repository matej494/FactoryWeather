//
//  RealmSettings.swift
//  FactoryWeather
//
//  Created by Matej Korman on 22/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSettings: Object {
    @objc dynamic var metric: Bool = true
    @objc dynamic var humidity: Bool = true
    @objc dynamic var windSpeed: Bool = true
    @objc dynamic var pressure: Bool = true
    
    convenience init(settings: Settings) {
        self.init()
        metric = settings.unit == Unit.metric
        humidity = settings.conditions.contains(.humidity)
        windSpeed = settings.conditions.contains(.windSpeed)
        pressure = settings.conditions.contains(.pressure)
    }
}

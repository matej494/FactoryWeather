//
//  Settings.swift
//  FactoryWeather
//
//  Created by Matej Korman on 22/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct Settings {
    var unit: Unit
    var conditions: Conditions
}

extension Settings {
    init(realmSettings: RealmSettings) {
        unit = realmSettings.metric ? .metric : .imperial
        conditions = Conditions().union(realmSettings.humidity ? [.humidity] : [])
            .union(realmSettings.windSpeed ? [.windSpeed] : [])
            .union(realmSettings.pressure ? [.pressure] : [])
    }
}

extension Settings: Equatable {
    static func == (lhs: Settings, rhs: Settings) -> Bool {
        return lhs.unit == rhs.unit &&
            lhs.conditions == rhs.conditions
    }
}

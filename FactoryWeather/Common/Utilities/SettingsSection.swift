//
//  SettingsSection.swift
//  FactoryWeather
//
//  Created by Matej Korman on 22/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

enum SettingsSection: Int {
    case locations
    case units
    case conditions 
    
    var count: Int {
        switch self {
        case .locations:
            return 3
        case .units:
            return Unit.allValuesCount
        case .conditions:
            return 1
        }
    }
    
    var localizedName: String {
        switch self {
        case .locations:
            return LocalizationKey.Settings.locationTableViewHeader.localized()
        case .units:
            return LocalizationKey.Settings.unitTableViewHeader.localized()
        case .conditions:
            return LocalizationKey.Settings.conditionsTableViewHeader.localized()
        }
    }
    
    static var allValuesCount: Int = {
        var counter = 0
        while let _ = SettingsSection(rawValue: counter) { counter += 1 }
        return counter
    }()
}

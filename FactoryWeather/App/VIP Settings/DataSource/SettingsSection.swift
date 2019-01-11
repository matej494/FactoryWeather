//
//  SettingsSection.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

enum SettingsSection: SectionProtocol, Equatable {
    case locations(rows: [SettingsRow])
    case units(rows: [SettingsRow])
    case conditions(rows: [SettingsRow])
    
    var rows: [SettingsRow] {
        switch self {
        case .locations(let rows):
            return rows
        case .units(let rows):
            return rows
        case .conditions(let rows):
            return rows
        }
    }
    
    var title: String {
        switch self {
        case .locations:
            return LocalizationKey.Settings.locationTableViewHeader.localized()
        case .units:
            return LocalizationKey.Settings.unitTableViewHeader.localized()
        case .conditions:
            return LocalizationKey.Settings.conditionsTableViewHeader.localized()
        }
    }
    
    static func == (lhs: SettingsSection, rhs: SettingsSection) -> Bool {
        switch (lhs, rhs) {
        case (.locations, .locations):
            return true
        case (.units, .units):
            return true
        case (.conditions, .conditions):
            return true
        default:
            return false
        }
    }
}

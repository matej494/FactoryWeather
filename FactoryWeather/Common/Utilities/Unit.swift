//
//  Unit.swift
//  FactoryWeather
//
//  Created by Matej Korman on 16/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

enum Unit: Int {
    case metric
    case imperial
    
    var localizedName: String {
        switch self {
        case .metric:
            return LocalizationKey.Settings.metricLabel.localized()
        case .imperial:
            return LocalizationKey.Settings.imperialLabel.localized()
        }
    }
    
    static var allValuesCount: Int {
        var counter = 0
        while let _ = Unit(rawValue: counter) { counter += 1 }
        return counter
    }
    
    func temperature(imperialValue value: Int) -> String {
        switch self {
        case .metric:
            return "\((value - 32) * 5 / 9)°"
        case .imperial:
            return "\(value)°"
        }
    }
    
    func temperature(imperialValue value: Float) -> String {
        switch self {
        case .metric:
            let metricValue = (value - 32) * 5 / 9
            return String(format: "%.1f°C", metricValue)
        case .imperial:
            return String(format: "%.1f°F", value)
        }
    }

    func humidity(value: Float) -> String {
        return "\(value * 100)%"
    }
    
    func windSpeed(imperialValue value: Float) -> String {
        switch self {
        case .metric:
            let metricValue = value * 0.44704
            return String(format: "%.1f m/s", metricValue)
        case .imperial:
            return String(format: "%.1f mph", value)
        }
    }
    
    func pressure(value: Float) -> String {
        return String(format: "%.1f hPa", value)
    }
}

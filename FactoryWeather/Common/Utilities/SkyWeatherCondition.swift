//
//  SkyWeatherCondition.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

enum SkyWeatherCondition {
    case day
    case rain
    case snow
    case night
    case fog
    
    var gradient: CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
        switch self {
        case .day:
            layer.colors = [UIColor.daySkyTop.cgColor, UIColor.daySkyBottom.cgColor]
        case .rain:
            layer.colors = [UIColor.rainSkyTop.cgColor, UIColor.rainSkyBottom.cgColor]
        case .snow:
            layer.colors = [UIColor.snowSkyTop.cgColor, UIColor.snowSkyBottom.cgColor]
        case .night:
            layer.colors = [UIColor.nightSkyTop.cgColor, UIColor.nightSkyBottom.cgColor]
        case .fog:
            layer.colors = [UIColor.fogSkyTop.cgColor, UIColor.fogSkyBottom.cgColor]
        }
        return layer
    }
    
    static func forIcon(_ icon: String) -> SkyWeatherCondition {
        if icon.contains("rain") || icon.contains("thunderstorm") || icon.contains("tornado") {
            return .rain
        } else if icon.contains("snow") || icon.contains("hail") || icon.contains("sleet") {
            return .snow
        } else if icon.contains("fog") {
            return .fog
        } else if icon.contains("night") {
            return .night
        } else {
            return .day
        }
    }
}

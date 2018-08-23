//
//  HomeViewModel.swift
//  FactoryWeather
//
//  Created by Matej Korman on 16/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit
import CoreLocation

struct HomeViewModel {
    let currentTemperature: String
    let lowTemperature: String
    let highTemperature: String
    let humidity: String
    let windSpeed: String
    let pressure: String
    let cityName: String
    let summary: String
    let skyGradient: CAGradientLayer
    let headerImage: UIImage
    let bodyImage: UIImage
    let visibleConditions: Conditions
    
    init(weatherData data: Weather, settings: Settings) {
        currentTemperature = settings.unit.temperature(imperialValue: Int(data.temperature))
        lowTemperature = settings.unit.temperature(imperialValue: data.temperatureLow)
        highTemperature = settings.unit.temperature(imperialValue: data.temperatureHigh)
        humidity = settings.unit.humidity(value: data.humidity)
        windSpeed = settings.unit.windSpeed(imperialValue: data.windSpeed)
        pressure = settings.unit.pressure(value: data.pressure)
        cityName = data.locationName
        summary = data.summary
        skyGradient = SkyWeatherCondition.forIcon(data.icon).gradient
        headerImage = UIImage(named: "header_image-\(data.icon)") ?? #imageLiteral(resourceName: "header_image-clear-day")
        bodyImage = UIImage(named: "body_image-\(data.icon)") ?? #imageLiteral(resourceName: "body_image-clear-day")
        visibleConditions = settings.conditions
    }
}

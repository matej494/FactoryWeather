//
//  Weather.swift
//  FactoryWeather
//
//  Created by Matej Korman on 16/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct Weather {
    var locationName: String
    var temperature: Float
    var summary: String
    var icon: String
    var humidity: Float
    var windSpeed: Float
    var pressure: Float
    var temperatureLow: Float
    var temperatureHigh: Float
    
    init(forecast: Forecast, locationName: String) {
        self.locationName = locationName
        temperature = forecast.currently.temperature
        summary = forecast.currently.summary
        icon = forecast.currently.icon
        humidity = forecast.currently.humidity
        windSpeed = forecast.currently.windSpeed
        pressure = forecast.currently.pressure
        temperatureLow = forecast.daily.data[0].temperatureLow
        temperatureHigh = forecast.daily.data[0].temperatureHigh
    }
}

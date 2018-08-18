//
//  Forecast.swift
//  FactoryWeather
//
//  Created by Matej Korman on 17/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let currently: Currently
    let daily: Daily
    
    struct Currently: Codable {
        let summary: String
        let icon: String
        let temperature: Float
        let humidity: Float
        let windSpeed: Float
        let pressure: Float
    }
    
    struct Daily: Codable {
        let data: [Data]
        
        struct Data: Codable {
            let temperatureHigh: Float
            let temperatureLow: Float
        }
    }
}

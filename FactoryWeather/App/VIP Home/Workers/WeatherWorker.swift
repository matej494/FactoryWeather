//
//  WeatherWorker.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import Promises

class WeatherWorker {
    func getWeather(forLocation location: Location) -> Promise<Weather> {
        return DarkSkyApiManager.getForecast(forLocation: location)
    }
}

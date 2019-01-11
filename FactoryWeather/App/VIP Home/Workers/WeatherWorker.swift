//
//  WeatherWorker.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

class WeatherWorker {
    func getWeather(forLocation location: Location, success: @escaping (Weather) -> Void, failure: @escaping (LocalizedError) -> Void) {
        DarkSkyApiManager.getForecast(forLocation: location,
                                      success: { success($0) },
                                      failure: { failure($0) })
    }
}

//
//  HomeInteractor.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import Promises

protocol HomeBusinessLogic {
    func getWeather(forLocation location: Location) -> Promise<(Weather, Settings)>
    func getDeviceLocation() -> Promise<Location>
}

class HomeInteractor {
    lazy var weatherWorker = WeatherWorker()
    lazy var deviceLocationWorker = DeviceLocationWorker()
    lazy var settingsWorker = SettingsWorker()
}

// MARK: - Business Logic
extension HomeInteractor: HomeBusinessLogic {
    func getWeather(forLocation location: Location) -> Promise<(Weather, Settings)> {
        return all(weatherWorker.getWeather(forLocation: location), settingsWorker.getSettings())
    }
    
    func getDeviceLocation() -> Promise<Location> {
        return deviceLocationWorker.getDeviceLocation()
    }
}

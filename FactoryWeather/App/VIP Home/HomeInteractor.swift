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
    /**
     - Parameters:
        - completion: Called when weather is successfully received
     */
    func getWeather(forLocation location: Location, completion: (() -> Void)?)
    //Maybe change name of function so it's obvious that it will get weather for Zagreb if device location is not available
    /**
     This function will get weather for device location if device
     location is available and if not, it will get weather for Zagreb.
     */
    func getWeatherForDeviceLocation()
}

class HomeInteractor {
    var presenter: HomePresentationLogic?
    lazy var weatherWorker = WeatherWorker()
    lazy var deviceLocationWorker = DeviceLocationWorker()
    lazy var settingsWorker = SettingsWorker()
}

// MARK: - Business Logic
extension HomeInteractor: HomeBusinessLogic {
    func getWeather(forLocation location: Location, completion: (() -> Void)?) {
        all(weatherWorker.getWeather(forLocation: location), settingsWorker.getSettings())
            .then { [weak self] weather, settings in
                self?.presenter?.presentWeather(weather, usingSettings: settings, forLocation: location)
                completion?()
            }
            .catch { print($0.localizedDescription) }
    }
    
    func getWeatherForDeviceLocation() {
        deviceLocationWorker.getDeviceLocation { [weak self] location in
            guard let location = location else {
                //Maybe notify user that device location is unavailable
                self?.getWeather(forLocation: Location(name: "Zagreb", country: "HR", latitude: 45.8150, longitude: 15.9819), completion: nil)
                return
            }
            self?.getWeather(forLocation: location, completion: nil)
        }
    }
}

//
//  HomeInteractor.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol HomeBusinessLogic {
    /**
     - Parameters:
        - completion: Called when weather is successfully received
     */
    func getWeather(forLocation location: Location, completion: (() -> Void)?)
    //Maybe change name of function so it's obvious that it will get weather for Zagreb if device location is not available
    func getWeatherForDeviceLocation()
}

class HomeInteractor {
    var presenter: HomePresentationLogic?
    lazy var weatherWorker = WeatherWorker()
    lazy var deviceLocationWorker = DeviceLocationWorker()
}

// MARK: - Business Logic
extension HomeInteractor: HomeBusinessLogic {
    func getWeather(forLocation location: Location, completion: (() -> Void)?) {
        weatherWorker.getWeather(forLocation: location,
            success: { [weak self] weather in
                self?.presenter?.presentWeather(weather, forLocation: location)
                completion?()
            }, failure: { print($0.localizedDescription) })
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

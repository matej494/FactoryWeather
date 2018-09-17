//
//  HomeViewModelImpl.swift
//  FactoryWeather
//
//  Created by Matej Korman on 10/09/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation
import CoreLocation

class HomeViewModelImpl: NSObject, HomeViewModel {
    private(set) var weather = Box<Weather?>(nil)
    private(set) var waitingResponse = Box<Bool>(false)
    private(set) var location = Location(name: "Zagreb", country: "HR", latitude: 45.8150, longitude: 15.9819)
    private(set) var settings = DataManager.getSettings()
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func dataChanged<T>(_ data: T) {
        if let location = data as? Location {
            self.location = location
        } else if let settings = data as? Settings {
            self.settings = settings
        } else if let weather = data as? Weather {
            self.weather.value = weather
        }
    }
}

extension HomeViewModelImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location
            else { return getWeather() }
        locationManager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, error in
            if let error = error {
                self?.getWeather()
                return print("Reverse geocoder failed with error" + error.localizedDescription)
            }
            let newLocation = Location(name: placemarks?.first?.locality ?? LocalizationKey.Home.deviceLocationUnknown.localized(),
                                       country: "",
                                       latitude: location.coordinate.latitude,
                                       longitude: location.coordinate.longitude)
            if newLocation != self?.location {
                self?.location = newLocation
            }
            self?.getWeather()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            getWeather()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
}

private extension HomeViewModelImpl {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func getWeather() {
        waitingResponse.value = true
        DarkSkyApiManager.getWeather(forLocation: location,
                                     success: { [weak self] weather in
                                        self?.waitingResponse.value = false
                                        self?.weather.value = weather },
                                     failure: { [weak self] error in
                                        self?.waitingResponse.value = false
                                        print(error.localizedDescription)
        })
    }
}

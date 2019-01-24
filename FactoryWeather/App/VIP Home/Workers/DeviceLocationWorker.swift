//
//  DeviceLocationWorker.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import CoreLocation
import Promises

enum DeviceLocationError: LocalizedError {
    case locationUnavailable
    case deviceLocationUnauthorised
    case generalError(Error)
    
    var errorDescription: String? {
        switch self {
        case .locationUnavailable:
            return "Location unavailable."
        case .generalError(let error):
            return "General error: \(error.localizedDescription)"
        case .deviceLocationUnauthorised:
            return "Device location is unauthorised. Change permission in settings."
        }
    }
}

class DeviceLocationWorker: NSObject {
    private var promise: Promise<Location>?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func getDeviceLocation() -> Promise<Location> {
        locationManager.requestWhenInUseAuthorization()
        let promise = Promise<Location>.pending()
        self.promise = promise
        return promise
    }
}

extension DeviceLocationWorker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            promise?.reject(DeviceLocationError.locationUnavailable)
            return
        }
        locationManager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, error in
            if let error = error {
                self?.promise?.reject(DeviceLocationError.generalError(error))
                return print("Reverse geocoder failed with error" + error.localizedDescription)
            }
            let newLocation = Location(name: placemarks?.first?.locality ?? LocalizationKey.Home.deviceLocationUnknown.localized(),
                                       country: "",
                                       latitude: location.coordinate.latitude,
                                       longitude: location.coordinate.longitude)
            self?.promise?.fulfill(newLocation)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            promise?.reject(DeviceLocationError.deviceLocationUnauthorised)
        } else {
            locationManager.startUpdatingLocation()
        }
    }
}

private extension DeviceLocationWorker {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
}

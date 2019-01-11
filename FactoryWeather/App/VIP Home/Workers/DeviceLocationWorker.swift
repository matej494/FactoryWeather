//
//  DeviceLocationWorker.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import CoreLocation

class DeviceLocationWorker: NSObject {
    private var completion: ((Location?) -> Void)?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func getDeviceLocation(completion: @escaping (_ location: Location?) -> Void) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
    }
}

extension DeviceLocationWorker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
                completion?(nil)
                return
        }
        locationManager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, error in
            if let error = error {
                self?.completion?(nil)
                return print("Reverse geocoder failed with error" + error.localizedDescription)
            }
            let newLocation = Location(name: placemarks?.first?.locality ?? LocalizationKey.Home.deviceLocationUnknown.localized(),
                                       country: "",
                                       latitude: location.coordinate.latitude,
                                       longitude: location.coordinate.longitude)
            self?.completion?(newLocation)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            completion?(nil)
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

//
//  SettingsInteractor.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol SettingsBusinessLogic {
    func deleteLocation(_ location: Location)
    func getSavedLocations()
    func getInitailData()
    
    /**
     Evaluates parameters and according to their state saves settings and calls completion
     - Parameters:
        - completion: Completion receives bollean if new weather should be requested
     */
    func doneTapped(selectedLocation: Location?, settings: Settings, completion: ((Bool) -> Void))
}

class SettingsInteractor {
    var presenter: SettingsPresentationLogic?
    lazy var settingsWorker = SettingsWorker()
    lazy var savedLocationsWorker = SavedLocationsWorker()
}

// MARK: - Business Logic
extension SettingsInteractor: SettingsBusinessLogic {
    func deleteLocation(_ location: Location) {
        savedLocationsWorker.deleteLocation(location)
        // We need to get new locations so we can update the view
        getSavedLocations()
    }
    
    func getSavedLocations() {
        let locations = savedLocationsWorker.getSavedLocations()
        presenter?.presentLocations(locations)
    }
    
    func getInitailData() {
        let locations = savedLocationsWorker.getSavedLocations()
        let settings = settingsWorker.getSettings()
        presenter?.presentInitialData(locations: locations, settings: settings)
    }
    
    func doneTapped(selectedLocation: Location?, settings: Settings, completion: ((Bool) -> Void)) {
        let oldSettings = settingsWorker.getSettings()
        if settings == oldSettings && selectedLocation == nil {
            return completion(false)
        }
        if settings != oldSettings { settingsWorker.saveSettings(settings) }
        completion(true)
    }
}

private extension SettingsInteractor { }

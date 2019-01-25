//
//  SettingsInteractor.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import Promises

protocol SettingsBusinessLogic {
    func deleteLocation(_ location: Location) -> Promise<Bool>
    func getSavedLocations() -> Promise<[Location]>
    func getSettings() -> Promise<Settings>
    func saveSettings(_ settings: Settings) -> Promise<Bool>
}

class SettingsInteractor {
    lazy var settingsWorker = SettingsWorker()
    lazy var savedLocationsWorker = SavedLocationsWorker()
}

// MARK: - Business Logic
extension SettingsInteractor: SettingsBusinessLogic {
    func deleteLocation(_ location: Location) -> Promise<Bool> {
        return savedLocationsWorker.deleteLocation(location)
    }
    
    func getSavedLocations() -> Promise<[Location]> {
        return savedLocationsWorker.getSavedLocations()
    }
    
    func getSettings() -> Promise<Settings> { 
        return settingsWorker.getSettings()
    }
    
    func saveSettings(_ settings: Settings) -> Promise<Bool> {
        return settingsWorker.saveSettings(settings)
    }
}

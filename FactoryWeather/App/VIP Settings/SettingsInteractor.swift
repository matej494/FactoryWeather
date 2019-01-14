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
    func deleteLocation(_ location: Location)
    func getSavedLocations()
    func getInitailData()
    
    /**
     Evaluates parameters and according to their state saves settings and calls completion
     - Parameters:
        - completion: Completion receives bollean if new weather should be requested
     */
    func doneTapped(selectedLocation: Location?, settings: Settings, completion: @escaping ((Bool) -> Void))
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
            .then { [weak self] _ in self?.getSavedLocations() }
            .catch { print($0) }
    }
    
    func getSavedLocations() {
        savedLocationsWorker.getSavedLocations()
            .then { [weak self] locations in self?.presenter?.presentLocations(locations) }
            .catch { error in print("Error geting saved locations: \(error)") }
    }
    
    func getInitailData() {
        all(on: DispatchQueue.global(qos: .background), savedLocationsWorker.getSavedLocations(), settingsWorker.getSettings())
            .then { [weak self] locations, settings in
                self?.presenter?.presentInitialData(locations: locations, settings: settings)
            }
            .catch { error in print("Error geting initial data: \(error)") }
    }
    
    func doneTapped(selectedLocation: Location?, settings: Settings, completion: @escaping ((Bool) -> Void)) {
        settingsWorker.getSettings()
            .then { [weak self] oldSettings -> Promise<Bool> in
                let promise = Promise<Bool>.pending()
                if let strongSelf = self,
                    settings != oldSettings {
                    strongSelf.settingsWorker.saveSettings(settings)
                        .then { _ in promise.fulfill(true) }
                        .catch { print("Error saving settings: \($0)") }
                } else { promise.fulfill(false) }
                return promise
            }
            .then { didSettingsChange in
                completion(didSettingsChange || selectedLocation =! nil)
            }
            .catch { print($0) }
    }
}

private extension SettingsInteractor { }

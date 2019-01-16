//
//  SettingsPresenter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol SettingsPresentationLogic {
    func presentLocations(_ locations: [Location])
    func presentInitialData(locations: [Location], settings: Settings)
}

class SettingsPresenter {
    private let MAX_NUMBER_OF_LOCATIONS = 3
    weak var viewController: SettingsDisplayLogic?
}

// MARK: - Presentation Logic
extension SettingsPresenter: SettingsPresentationLogic {
    func presentLocations(_ locations: [Location]) {
        let max3Locations = Array(locations[0...min(MAX_NUMBER_OF_LOCATIONS, locations.count)])
        viewController?.displayLocations(max3Locations)
    }
    
    func presentInitialData(locations: [Location], settings: Settings) {
        let max3Locations = Array(locations[0...min(MAX_NUMBER_OF_LOCATIONS, locations.count)])
        viewController?.displayInitialData(locations: max3Locations, settings: settings)
    }
}

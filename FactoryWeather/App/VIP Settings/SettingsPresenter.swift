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
        let max3Locations = locations.enumerated().compactMap { $0.offset < MAX_NUMBER_OF_LOCATIONS ? $0.element : nil }
        //NOTE: Check which solution is better
//        let max3Locations = locations.count <= MAX_NUMBER_OF_LOCATIONS ?
//            locations : Array(locations.dropLast(locations.count - MAX_NUMBER_OF_LOCATIONS))
        viewController?.displayLocations(max3Locations)
    }
    
    func presentInitialData(locations: [Location], settings: Settings) {
        let max3Locations = locations.enumerated().compactMap { $0.offset < MAX_NUMBER_OF_LOCATIONS ? $0.element : nil }
        viewController?.initializeDisplay(locations: max3Locations, settings: settings)
    }
}

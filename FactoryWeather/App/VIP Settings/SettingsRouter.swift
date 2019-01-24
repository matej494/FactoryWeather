//
//  SettingsRouter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol SettingsRoutingLogic {
    func requestNewWeatherData(selectedLocation: Location?)
    func unwindBack()
}

protocol SettingsSceneDelegate: class {
    func settingsRouterRequestedWeatherUpdate(selectedLocation: Location?)
    func settingRouterRequestedUnwindBack()
}

class SettingsRouter {
    weak var viewController: SettingsViewController?
    weak var delegate: SettingsSceneDelegate?
}

// MARK: - Routing Logic
extension SettingsRouter: SettingsRoutingLogic {
    func requestNewWeatherData(selectedLocation: Location?) {
        delegate?.settingsRouterRequestedWeatherUpdate(selectedLocation: selectedLocation)
    }
    
    func unwindBack() {
        delegate?.settingRouterRequestedUnwindBack()
    }
}

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

protocol SettingsRouterDelegate: class {
    func requestNewWeatherData(selectedLocation: Location?)
    func unwindBack()
}

class SettingsRouter {
    weak var viewController: SettingsViewController?
    weak var delegate: SettingsRouterDelegate?
}

// MARK: - Routing Logic
extension SettingsRouter: SettingsRoutingLogic {
    func requestNewWeatherData(selectedLocation: Location?) {
        delegate?.requestNewWeatherData(selectedLocation: selectedLocation)
    }
    
    func unwindBack() {
        delegate?.unwindBack()
    }
}

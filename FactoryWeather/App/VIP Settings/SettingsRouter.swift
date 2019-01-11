//
//  SettingsRouter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol SettingsRoutingLogic {
    func getNewWeather(selectedLocation: Location?)
    func dismissSettingsScene()
}

protocol SettingsRouterDelegate: class {
    func getNewWeather(selectedLocation: Location?)
    func dismissSettingsScene()
}

class SettingsRouter {
    weak var viewController: SettingsViewController?
    weak var delegate: SettingsRouterDelegate?
}

// MARK: - Routing Logic
extension SettingsRouter: SettingsRoutingLogic {
    func getNewWeather(selectedLocation: Location?) {
        delegate?.getNewWeather(selectedLocation: selectedLocation)
    }
    
    func dismissSettingsScene() {
        delegate?.dismissSettingsScene()
    }
}

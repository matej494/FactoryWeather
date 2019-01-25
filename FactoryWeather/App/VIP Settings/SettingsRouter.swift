//
//  SettingsRouter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

enum SettingsNavigationOption {
    case unwindBack
}

protocol SettingsRoutingLogic: class {
    func requestNewWeatherData(selectedLocation: Location?)
    func navigate(to option: SettingsNavigationOption)
}

protocol SettingsSceneDelegate: class {
    func settingsRouterRequestedWeatherUpdate(selectedLocation: Location?)
    func settingRouterRequestedUnwindBack()
}

class SettingsRouter {
    weak var delegate: SettingsSceneDelegate?
    private var presenter: SettingsPresenter?
    private var viewController: SettingsViewController?
    
    init(delegate: SettingsSceneDelegate?) {
        self.delegate = delegate
    }
}

extension SettingsRouter {
    func buildScene() -> SettingsViewController {
        let viewController = SettingsViewController()
        //TODO: Inject workers for testability
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter(viewController: viewController, interactor: interactor)
        viewController.presenter = presenter
        presenter.router = self
        self.presenter = presenter
        self.viewController = viewController
        return viewController
    }
}

// MARK: - Routing Logic
extension SettingsRouter: SettingsRoutingLogic {
    func requestNewWeatherData(selectedLocation: Location?) {
        delegate?.settingsRouterRequestedWeatherUpdate(selectedLocation: selectedLocation)
    }
    
    func navigate(to option: SettingsNavigationOption) {
        switch option {
        case .unwindBack:
            delegate?.settingRouterRequestedUnwindBack()
        }
    }
}

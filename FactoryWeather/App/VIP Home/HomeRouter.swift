//
//  HomeRouter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol HomeRoutingLogic {
    func openSettings(oldLocation location: Location)
    func openSearch()
}

protocol HomeRouterDelegate: class { }

class HomeRouter {
    weak var viewController: HomeViewController?
    weak var delegate: HomeRouterDelegate?
}

// MARK: - Routing Logic
extension HomeRouter: HomeRoutingLogic {
    func openSettings(oldLocation location: Location) {
        let settingsViewController = SettingsViewController(delegate: self)
        settingsViewController.modalPresentationStyle = .overCurrentContext
        viewController?.present(settingsViewController, animated: true, completion: nil)
    }
    
    func openSearch() {
        guard let viewController = viewController else { return }
        let searchViewController = SearchViewController(safeAreaInsets: viewController.view.safeAreaInsets, delegate: self)
        searchViewController.transitioningDelegate = viewController
        searchViewController.modalPresentationStyle = .custom
        viewController.present(searchViewController, animated: true, completion: nil)
    }
}

extension HomeRouter: SettingsRouterDelegate {
    func settingsRouterRequestedNewWeatherData(selectedLocation: Location?) {
        viewController?.getWeather(forLocation: selectedLocation, completion: { [weak self] in self?.settingRouterUnwindBack() })
    }
    
    func settingRouterUnwindBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

extension HomeRouter: SearchRouterDelegate {
    func searchRouterSetSearchTextFieldHidden(_ hidden: Bool) {
        viewController?.setSearchTextFieldHidden(hidden)
    }
    
    func searchRouterRequestNewWeatherData(selectedLocation: Location?) {
        viewController?.getWeather(forLocation: selectedLocation, completion: { [weak self] in self?.searchRouterUnwindBack() })
    }
    
    func searchRouterUnwindBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

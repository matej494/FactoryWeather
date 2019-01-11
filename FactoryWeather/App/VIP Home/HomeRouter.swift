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
        let settingsViewController = SettingsViewController(location: location)
        settingsViewController.settingsChanged = { [weak self] newLocation, weather in
            self?.viewController?.getWeather(forLocation: newLocation)
            //Notify settingsViewController if the getWeather was successfull ??
        }
        settingsViewController.modalPresentationStyle = .overCurrentContext
        viewController?.present(settingsViewController, animated: true, completion: nil)
    }
    
    func openSearch() {
        guard let viewController = viewController else { return }
        let searchViewController = SearchViewController(safeAreaInsets: viewController.view.safeAreaInsets)
        searchViewController.didSelectLocation = { [weak self] weather, location in
            self?.viewController?.getWeather(forLocation: location)
        }
        searchViewController.searchTextFieldIsHidden = { [weak self] isHidden in
            self?.viewController?.setSearchTextFieldHidden(isHidden)
        }
        searchViewController.transitioningDelegate = viewController
        searchViewController.modalPresentationStyle = .custom
        viewController.present(searchViewController, animated: true, completion: nil)
    }
}

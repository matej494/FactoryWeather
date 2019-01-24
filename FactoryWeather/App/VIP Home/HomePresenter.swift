//
//  HomePresenter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol: class {
    func viewWillAppear()
    func settingsButtonTapped()
    func searchTextFieldSelected()
}

class HomePresenter {
    weak var router: HomeRoutingLogic?
    private let dataSource = HomeDataSource()
    private let viewController: HomeDisplayLogic
    private let interactor: HomeBusinessLogic
    
    init(viewController: HomeDisplayLogic, interactor: HomeBusinessLogic) {
        self.viewController = viewController
        self.interactor = interactor
    }
}

extension HomePresenter: HomePresenterProtocol {
    func viewWillAppear() {
        viewController.showActivityIndicator(true)
        interactor.getDeviceLocation()
            .recover { error -> Location in
                print(error.localizedDescription)
                return Location(name: "Zagreb", country: "HR", latitude: 45.8150, longitude: 15.9819)
            }
            .then { [weak self] location in
                self?.dataSource.location = location
                self?.interactor.getWeather(forLocation: location)
                    .then { [weak self] (weather, settings) in self?.presentWeather(weather, usingSettings: settings, forLocation: location) }
            }
            .catch { print($0.localizedDescription) }
    }
    
    func settingsButtonTapped() {
        router?.navigate(to: .settings)
    }
    
    func searchTextFieldSelected() {
        router?.navigate(to: .search)
    }
}

extension HomePresenter: SettingsSceneDelegate {
    func settingsRouterRequestedWeatherUpdate(selectedLocation: Location?) {
        getWeatherAndDismissPresentedScene(selectedLocation: selectedLocation ?? dataSource.location)
    }
    
    func settingRouterRequestedUnwindBack() {
        router?.navigate(to: .thisScene)
    }
}

extension HomePresenter: SearchSceneDelegate {
    func searchRouterRequestedToSetSearchTextFieldHidden(_ hidden: Bool) {
        viewController.setSearchTextFieldHidden(hidden)
    }
    
    func searchRouterRequestWeatherUpdate(selectedLocation: Location?) {
        getWeatherAndDismissPresentedScene(selectedLocation: selectedLocation ?? dataSource.location)
    }
    
    func searchRouterRequestedUnwindBack() {
        router?.navigate(to: .thisScene)
    }
}

private extension HomePresenter {
    func presentWeather(_ weather: Weather, usingSettings settings: Settings, forLocation location: Location) {
        let viewModel = dataSource.createHomeContentViewModel(withWeather: weather, usingSettings: settings)
        viewController.displayWeather(viewModel, forLocation: location)
        viewController.showActivityIndicator(false)
    }
    
    func getWeatherAndDismissPresentedScene(selectedLocation location: Location) {
        interactor.getWeather(forLocation: location)
            .then { [weak self] (weather, settings) in
                self?.presentWeather(weather, usingSettings: settings, forLocation: location)
                self?.router?.navigate(to: .thisScene)
            }
            .catch { print($0.localizedDescription) }
    }
}

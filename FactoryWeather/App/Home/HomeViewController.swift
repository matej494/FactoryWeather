//
//  HomeViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class HomeViewController: UIViewController {
    // NOTE: Fixed location. Will be replaced with device location.
    private var location = Location(name: "Osijek", country: "HR", latitude: 45.55111, longitude: 18.69389)
    private var settings = DataManager.getSettings()
    private let homeView = HomeView.autolayoutView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
        DarkSkyApiManager.getForecast(forLocation: location,
                                      success: { [weak self] weather in
                                        self?.updateHomeViewProperties(withWeatherData: weather) },
                                      failure: { error in
                                        print(error.localizedDescription)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeViewController {
    func setupView() {
        setupCallbacks()
        view.backgroundColor = .white
        view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
    
    func setupCallbacks() {
        homeView.didSelectSearchTextField = { [weak self] in
            let searchViewController = SearchViewController()
            searchViewController.didSelectLocation = { [weak self] weather, location in
                self?.location = location
                self?.updateHomeViewProperties(withWeatherData: weather)
            }
            searchViewController.modalPresentationStyle = .overCurrentContext
            self?.present(searchViewController, animated: true, completion: nil)
        }
        homeView.didTapOnSettingsButton = { [weak self] in
            guard let strongSelf = self
                else { return }
            let settingsViewController = SettingsViewController(location: strongSelf.location)
            settingsViewController.settingsChanged = { [weak self] newLocation, weather in
                self?.settings = DataManager.getSettings()
                self?.location = newLocation
                self?.updateHomeViewProperties(withWeatherData: weather)
            }
            settingsViewController.modalPresentationStyle = .overCurrentContext
            strongSelf.present(settingsViewController, animated: true, completion: nil)
        }
    }
    
    func updateHomeViewProperties(withWeatherData weather: Weather) {
        let homeViewModel = HomeViewModel(weatherData: weather, settings: settings)
        homeView.updateProperties(withData: homeViewModel)
    }
}

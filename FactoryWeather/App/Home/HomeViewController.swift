//
//  HomeViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit
import CoreLocation

class HomeViewController: UIViewController {
    // NOTE: Fixed location. Will be used if device location isn't authorised or fails.
    private var location = Location(name: "Zagreb", country: "HR", latitude: 45.8150, longitude: 15.9819)
    private var settings = DataManager.getSettings()
    private let homeView = HomeView.autolayoutView()
    private let locationManager = CLLocationManager()
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location
            else { return getWeatherAndUpdateView() }
        locationManager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, error in
            if let error = error {
                self?.getWeatherAndUpdateView()
                return print("Reverse geocoder failed with error" + error.localizedDescription)
            }
            let newLocation = Location(name: placemarks?.first?.locality ?? LocalizationKey.Home.deviceLocationUnknown.localized(),
                                       country: "",
                                       latitude: location.coordinate.latitude,
                                       longitude: location.coordinate.longitude)
            if newLocation != self?.location {
                self?.location = newLocation
            }
            self?.getWeatherAndUpdateView()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            getWeatherAndUpdateView()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
}

private extension HomeViewController {
    func setupView() {
        setupCallbacks()
        view.backgroundColor = .white
        view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
        activityIndicatorView.startAnimating()
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
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func updateHomeViewProperties(withWeatherData weather: Weather) {
        let homeViewModel = HomeViewModel(weatherData: weather, settings: settings)
        homeView.updateProperties(withData: homeViewModel)
    }
    
    func getWeatherAndUpdateView() {
        DarkSkyApiManager.getForecast(forLocation: location,
                                      success: { [weak self] weather in
                                        self?.activityIndicatorView.stopAnimating()
                                        self?.updateHomeViewProperties(withWeatherData: weather) },
                                      failure: { [weak self] error in
                                        self?.activityIndicatorView.stopAnimating()
                                        print(error.localizedDescription)
        })
    }
}

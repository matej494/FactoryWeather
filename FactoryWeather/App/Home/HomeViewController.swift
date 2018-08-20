//
//  HomeViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class HomeViewController: UIViewController {
    private let homeView = HomeView.autolayoutView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
        // NOTE: Fixed location data. Will be replaced when searching is implemented.
        DarkSkyApiManager.getForecast(forLocation: Location(name: "Osijek", country: "CRO", latitude: 45.5550, longitude: 18.6955),
                                      success: { [weak self] weather in
                                        self?.homeView.updateProperties(withData: HomeViewModel(weatherData: weather,
                                                                                                unit: .metric,
                                                                                                visibleConditions: HomeViewModel.VisibleConditions(humidity: true, windSpeed: true, pressure: true))) },
                                      failure: { error in
                                        print(error.localizedDescription) })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeViewController {
    func setupView() {
        view.backgroundColor = .white
        homeView.didSelectSearchTextField = { [weak self] in
            let searchViewController = SearchViewController()
            searchViewController.didSelectLocation = { [weak self] weather in
                self?.homeView.updateProperties(withData: HomeViewModel(weatherData: weather,
                                                                        unit: .metric,
                                                                        visibleConditions: HomeViewModel.VisibleConditions(humidity: true, windSpeed: true, pressure: true)))
            }
            searchViewController.modalPresentationStyle = .overCurrentContext
            self?.present(searchViewController, animated: true, completion: nil)
        }
        view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
}

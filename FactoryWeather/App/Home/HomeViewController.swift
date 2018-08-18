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
        // NOTE: Dummy data. Will be replaced when network is implemented.
        homeView.updateProperties(withData: HomeViewModel(weatherData: Weather(location: "London",
                                                                               temperature: 66.1,
                                                                               summary: "Drizzle",
                                                                               icon: "rain",
                                                                               humidity: 0.83,
                                                                               windSpeed: 5.59,
                                                                               pressure: 1010.34,
                                                                               temperatureLow: 41.28,
                                                                               temperatureHigh: 66.35),
                                                          unit: .metric,
                                                          visibleConditions: HomeViewModel.VisibleConditions(humidity: true,
                                                                                                             windSpeed: true,
                                                                                                             pressure: false)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
}

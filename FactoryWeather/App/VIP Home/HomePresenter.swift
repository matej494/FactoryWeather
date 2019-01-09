//
//  HomePresenter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol HomePresentationLogic {
    func presentWeather(_ weather: Weather, forLocation location: Location)
}

class HomePresenter {
    weak var viewController: HomeDisplayLogic?
}

// MARK: - Presentation Logic
extension HomePresenter: HomePresentationLogic {
    func presentWeather(_ weather: Weather, forLocation location: Location) {
        let data = HomeDataSource(weatherData: weather)
        viewController?.displayWeather(data, forLocation: location)
    }
}

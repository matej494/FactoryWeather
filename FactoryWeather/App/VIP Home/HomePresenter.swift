//
//  HomePresenter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func presentWeather(_ weather: Weather, forLocation location: Location)
}

class HomePresenter {
    weak var viewController: HomeDisplayLogic?
}

// MARK: - Presentation Logic
extension HomePresenter: HomePresentationLogic {
    func presentWeather(_ weather: Weather, forLocation location: Location) {
        let homeContentViewModel = createHomeContentViewModel(withWeather: weather)
        viewController?.displayWeather(homeContentViewModel, forLocation: location)
    }
}

private extension HomePresenter {
    func createHeaderViewModel(withWeather weather: Weather, usingSettings settings: Settings) -> HeaderView.ViewModel {
        return HeaderView.ViewModel(headerImage: UIImage(named: "header_image-\(weather.icon)") ?? #imageLiteral(resourceName: "header_image-clear-day"),
                                    currentTemperature: settings.unit.temperature(imperialValue: Int(weather.temperature)),
                                    summary: weather.summary)
    }

    func createBodyViewModel(withWeather weather: Weather, usingSettings settings: Settings) -> BodyView.ViewModel {
        return BodyView.ViewModel(bodyImage: UIImage(named: "body_image-\(weather.icon)") ?? #imageLiteral(resourceName: "body_image-clear-day"),
                                  cityName: weather.locationName,
                                  lowTemperature: settings.unit.temperature(imperialValue: weather.temperatureLow),
                                  highTemperature: settings.unit.temperature(imperialValue: weather.temperatureHigh),
                                  humidity: settings.unit.humidity(value: weather.humidity),
                                  windSpeed: settings.unit.windSpeed(imperialValue: weather.windSpeed),
                                  pressure: settings.unit.pressure(value: weather.pressure),
                                  visibleConditions: settings.conditions)
    }
    
    func createHomeContentViewModel(withWeather weather: Weather) -> HomeContentView.ViewModel {
        let settings = DataManager.getSettings()
        let headerViewModel = createHeaderViewModel(withWeather: weather, usingSettings: settings)
        let bodyViewModel = createBodyViewModel(withWeather: weather, usingSettings: settings)
        return HomeContentView.ViewModel(skyGradient: SkyWeatherCondition.forIcon(weather.icon).gradient,
                                         headerViewModel: headerViewModel,
                                         bodyViewModel: bodyViewModel)
    }
}

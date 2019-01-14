//
//  HomePresenter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import UIKit
import Promises

protocol HomePresentationLogic {
    func presentWeather(_ weather: Weather, forLocation location: Location)
}

class HomePresenter {
    weak var viewController: HomeDisplayLogic?
}

// MARK: - Presentation Logic
extension HomePresenter: HomePresentationLogic {
    func presentWeather(_ weather: Weather, forLocation location: Location) {
        createHomeContentViewModel(withWeather: weather)
            .then { [weak self] viewModel in
                self?.viewController?.displayWeather(viewModel, forLocation: location)
            }
            .catch { print($0) }
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
    
    func createHomeContentViewModel(withWeather weather: Weather) -> Promise<HomeContentView.ViewModel> {
        return DataManager.getSettings()
            .then { [weak self] settings in
                guard let strongSelf = self else { return Promise(CustomError()) }
                let headerViewModel = strongSelf.createHeaderViewModel(withWeather: weather, usingSettings: settings)
                let bodyViewModel = strongSelf.createBodyViewModel(withWeather: weather, usingSettings: settings)
                return Promise(HomeContentView.ViewModel(skyGradient: SkyWeatherCondition.forIcon(weather.icon).gradient,
                                                 headerViewModel: headerViewModel,
                                                 bodyViewModel: bodyViewModel))
            }
    }
}

struct CustomError: LocalizedError {
    var generalError = "generalError"
}

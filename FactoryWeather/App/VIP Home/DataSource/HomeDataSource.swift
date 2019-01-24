//
//  HomeDataSource.swift
//  FactoryWeather
//
//  Created by Matej Korman on 23/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import UIKit

class HomeDataSource {
    var location = Location(name: "Zagreb", country: "HR", latitude: 45.8150, longitude: 15.9819)
}

extension HomeDataSource {
    func createHomeContentViewModel(withWeather weather: Weather, usingSettings settings: Settings) -> HomeContentView.ViewModel {
        let headerViewModel = createHeaderViewModel(withWeather: weather, usingSettings: settings)
        let bodyViewModel = createBodyViewModel(withWeather: weather, usingSettings: settings)
        return HomeContentView.ViewModel(skyGradient: SkyWeatherCondition.forIcon(weather.icon).gradient,
                                         headerViewModel: headerViewModel,
                                         bodyViewModel: bodyViewModel)
    }
}

private extension HomeDataSource {
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
}

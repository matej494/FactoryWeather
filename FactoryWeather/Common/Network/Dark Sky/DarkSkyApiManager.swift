//
//  DarkSkyApiManager.swift
//  FactoryWeather
//
//  Created by Matej Korman on 17/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation
import Promises

struct DarkSkyApiManager {
    static func getForecast(forLocation location: Location) -> Promise<Weather> {
        return Promise { fulfill, reject in
            guard let url = createUrl(forLocation: location)
                else { return reject(NetworkManagerError.urlCreationFailure) }
            var request = URLRequest(url: url)
            request.httpMethod = HTTPRequestMethod.get.rawValue
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    return reject(NetworkManagerError.generic(error))
                }
                do {
                    guard let unwrappedData = data
                        else { return reject(NetworkManagerError.dataUnwrappingFailure) }
                    let forecast = try JSONDecoder().decode(Forecast.self, from: unwrappedData)
                    let weather = Weather(forecast: forecast, locationName: location.name)
                    return fulfill(weather)
                } catch {
                    return reject(NetworkManagerError.parsingDataFailure)
                }
            }.resume()
        }
    }
}

private extension DarkSkyApiManager {
    static func createUrl(forLocation location: Location) -> URL? {
        let currentTime = Date().timeIntervalSince1970
        guard let url = DarkSkyApi.url?.appendingPathComponent(DarkSkyApi.locationParameter(location) + DarkSkyApi.timeParameter(currentTime)),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else { return nil }
        urlComponents.queryItems = [DarkSkyApi.excludingProperties]
        return urlComponents.url
    }
}

//
//  DarkSkyApiManager.swift
//  FactoryWeather
//
//  Created by Matej Korman on 17/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct DarkSkyApiManager {
    static func getForecast(forLocation location: Location, success: @escaping (Weather) -> Void, failure: @escaping (LocalizedError) -> Void) {
        guard let url = createUrl(forLocation: location)
            else { return DispatchQueue.main.async { failure(DarkSkyApiManagerError.urlCreationFailure) } }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPRequestMethod.get.rawValue
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                return DispatchQueue.main.async { failure(DarkSkyApiManagerError.generic(error)) }
            }
            do {
                guard let unwrappedData = data
                    else { return DispatchQueue.main.async { failure(DarkSkyApiManagerError.dataUnwrappingFailure) } }
                let forecast = try JSONDecoder().decode(Forecast.self, from: unwrappedData)
                let weather = Weather(forecast: forecast)
                return DispatchQueue.main.async { success(weather) }
            } catch {
                return DispatchQueue.main.async { failure(DarkSkyApiManagerError.parsingDataFailure) }
            }
        }
        task.resume()
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

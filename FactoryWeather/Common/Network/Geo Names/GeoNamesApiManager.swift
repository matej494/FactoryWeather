//
//  GeoNamesApiManager.swift
//  FactoryWeather
//
//  Created by Matej Korman on 20/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct GeoNamesApiManager {
    static func getLocations(forText text: String, success: @escaping ([Location]) -> Void, failure: @escaping (LocalizedError) -> Void) {
        guard let url = createUrl(forText: text)
            else { return DispatchQueue.main.async { failure(NetworkManagerError.urlCreationFailure) } }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPRequestMethod.get.rawValue
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                return DispatchQueue.main.async { failure(NetworkManagerError.generic(error)) }
            }
            do {
                guard let unwrappedData = data
                    else { return DispatchQueue.main.async { failure(NetworkManagerError.dataUnwrappingFailure) } }
                let geoName = try JSONDecoder().decode(GeoName.self, from: unwrappedData)
                return DispatchQueue.main.async { success(geoName.locations) }
            } catch {
                return DispatchQueue.main.async { failure(NetworkManagerError.parsingDataFailure) }
            }
        }
        task.resume()
    }
}

private extension GeoNamesApiManager {
    static func createUrl(forText text: String) -> URL? {
        guard let url = GeoNamesApi.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else { return nil }
        urlComponents.queryItems = [GeoNamesApi.query(forText: text), GeoNamesApi.maxNumberOfRows(10), GeoNamesApi.orderByRelevance, GeoNamesApi.shortStyle, GeoNamesApi.username]
        return urlComponents.url
    }
}

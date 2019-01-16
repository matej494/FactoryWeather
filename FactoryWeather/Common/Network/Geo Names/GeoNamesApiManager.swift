//
//  GeoNamesApiManager.swift
//  FactoryWeather
//
//  Created by Matej Korman on 20/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation
import Promises

struct GeoNamesApiManager {
    static func getLocations(forText text: String) -> Promise<[Location]> {
        return Promise(on: DispatchQueue.global(qos: .background)) { fulfill, reject in
            guard let url = createUrl(forText: text)
                else { return reject(NetworkManagerError.urlCreationFailure) }
            var request = URLRequest(url: url)
            request.httpMethod = HTTPRequestMethod.get.rawValue
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error { return reject(NetworkManagerError.generic(error)) }
                do {
                    guard let unwrappedData = data
                        else { return reject(NetworkManagerError.dataUnwrappingFailure) }
                    let geoName = try JSONDecoder().decode(GeoName.self, from: unwrappedData)
                    return fulfill(geoName.locations)
                } catch {
                    return reject(NetworkManagerError.parsingDataFailure)
                }
            }.resume()
        }
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

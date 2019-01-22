//
//  LocationsWorker.swift
//  FactoryWeather
//
//  Created by Matej Korman on 15/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import Promises

class LocationsWorker {
    func getLocations(forText text: String) -> Promise<[Location]> {
        return GeoNamesApiManager.getLocations(forText: text)
    }
}

//
//  SearchInteractor.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import Promises

protocol SearchBusinessLogic {
    func getLocations(forText text: String) -> Promise<[Location]>
}

class SearchInteractor {
    lazy var locationsWorker = LocationsWorker()
}

// MARK: - Business Logic
extension SearchInteractor: SearchBusinessLogic {
    func getLocations(forText text: String) -> Promise<[Location]> {
        return locationsWorker.getLocations(forText: text)
    }
}

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
    func getLocations(forText text: String)
}

class SearchInteractor {
    var presenter: SearchPresentationLogic?
    lazy var locationsWorker = LocationsWorker()
}

// MARK: - Business Logic
extension SearchInteractor: SearchBusinessLogic {
    func getLocations(forText text: String) {
        locationsWorker.getLocations(forText: text)
            .then { [weak self] locations in self?.presenter?.presentLocations(locations) }
            .catch { [weak self] error in self?.presenter?.presentError(error) }
    }
}

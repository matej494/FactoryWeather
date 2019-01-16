//
//  SearchPresenter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol SearchPresentationLogic {
    func presentLocations(_ locations: [Location])
    func presentError(_ error: Error)
}

class SearchPresenter {
    weak var viewController: SearchDisplayLogic?
}

// MARK: - Presentation Logic
extension SearchPresenter: SearchPresentationLogic {
    func presentLocations(_ locations: [Location]) {
        viewController?.displayLocations(locations)
    }
    
    func presentError(_ error: Error) {
        viewController?.displayError(error)
    }
}

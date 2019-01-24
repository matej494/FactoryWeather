//
//  SearchRouter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

protocol SearchRoutingLogic {
    func setSearchTextFieldHidden(_ hidden: Bool)
    func requestNewWeatherData(forLocation location: Location)
    func unwindBack()
}

protocol SearchSceneDelegate: class {
    func searchRouterRequestedToSetSearchTextFieldHidden(_ hidden: Bool)
    func searchRouterRequestWeatherUpdate(selectedLocation: Location?)
    func searchRouterRequestedUnwindBack()
}

class SearchRouter {
    weak var viewController: SearchViewController?
    weak var delegate: SearchSceneDelegate?
}

// MARK: - Routing Logic
extension SearchRouter: SearchRoutingLogic {
    func setSearchTextFieldHidden(_ hidden: Bool) {
        delegate?.searchRouterRequestedToSetSearchTextFieldHidden(hidden)
    }
    
    func requestNewWeatherData(forLocation location: Location) {
        delegate?.searchRouterRequestWeatherUpdate(selectedLocation: location)
    }
    
    func unwindBack() {
        delegate?.searchRouterRequestedUnwindBack()
    }
}

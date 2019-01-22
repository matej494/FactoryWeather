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

protocol SearchRouterDelegate: class {
    func searchRouterSetSearchTextFieldHidden(_ hidden: Bool)
    func searchRouterRequestNewWeatherData(selectedLocation: Location?)
    func searchRouterUnwindBack()
}

class SearchRouter {
    weak var viewController: SearchViewController?
    weak var delegate: SearchRouterDelegate?
}

// MARK: - Routing Logic
extension SearchRouter: SearchRoutingLogic {
    func setSearchTextFieldHidden(_ hidden: Bool) {
        delegate?.searchRouterSetSearchTextFieldHidden(hidden)
    }
    
    func requestNewWeatherData(forLocation location: Location) {
        delegate?.searchRouterRequestNewWeatherData(selectedLocation: location)
    }
    
    func unwindBack() {
        delegate?.searchRouterUnwindBack()
    }
}

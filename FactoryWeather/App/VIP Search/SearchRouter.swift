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
    func setSearchTextFieldHidden(_ hidden: Bool)
    func requestNewWeatherData(selectedLocation: Location?)
    func unwindBack()
}

class SearchRouter {
    weak var viewController: SearchViewController?
    weak var delegate: SearchRouterDelegate?
}

// MARK: - Routing Logic
extension SearchRouter: SearchRoutingLogic {
    func setSearchTextFieldHidden(_ hidden: Bool) {
        delegate?.setSearchTextFieldHidden(hidden)
    }
    
    func requestNewWeatherData(forLocation location: Location) {
        delegate?.requestNewWeatherData(selectedLocation: location)
    }
    
    func unwindBack() {
        delegate?.unwindBack()
    }
}

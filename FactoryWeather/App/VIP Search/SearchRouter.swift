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
    func locationSelected(_ location: Location)
    func dismiss()
}

protocol SearchRouterDelegate: class {
    func setSearchTextFieldHidden(_ hidden: Bool)
    func getNewWeather(selectedLocation: Location?)
    func dismissSearchScene()
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
    
    func locationSelected(_ location: Location) {
        delegate?.getNewWeather(selectedLocation: location)
    }
    
    func dismiss() {
        delegate?.dismissSearchScene()
    }
}

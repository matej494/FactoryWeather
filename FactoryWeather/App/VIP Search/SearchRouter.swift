//
//  SearchRouter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import UIKit

enum SearchNavigationOption {
    case unwindBack
}

protocol SearchRoutingLogic: class {
    func setSearchTextFieldHidden(_ hidden: Bool)
    func requestNewWeatherData(forLocation location: Location)
    func navigate(to option: SearchNavigationOption)
}

protocol SearchSceneDelegate: class {
    func searchRouterRequestedToSetSearchTextFieldHidden(_ hidden: Bool)
    func searchRouterRequestWeatherUpdate(selectedLocation: Location?)
    func searchRouterRequestedUnwindBack()
}

class SearchRouter {
    weak var delegate: SearchSceneDelegate?
    private var presenter: SearchPresenter?
    private var viewController: SearchViewController?
    
    init(delegate: SearchSceneDelegate?) {
        self.delegate = delegate
    }
}

extension SearchRouter {
    func buildScene(safeAreaInsets: UIEdgeInsets) -> SearchViewController {
        let viewController = SearchViewController(safeAreaInsets: safeAreaInsets)
        //TODO: Inject workers for testability
        let interactor = SearchInteractor()
        let presenter = SearchPresenter(viewController: viewController, interactor: interactor)
        viewController.presenter = presenter
        presenter.router = self
        self.presenter = presenter
        self.viewController = viewController
        return viewController
    }
}

// MARK: - Routing Logic
extension SearchRouter: SearchRoutingLogic {
    func setSearchTextFieldHidden(_ hidden: Bool) {
        delegate?.searchRouterRequestedToSetSearchTextFieldHidden(hidden)
    }
    
    func requestNewWeatherData(forLocation location: Location) {
        delegate?.searchRouterRequestWeatherUpdate(selectedLocation: location)
    }
    
    func navigate(to option: SearchNavigationOption) {
        switch option {
        case .unwindBack:
            delegate?.searchRouterRequestedUnwindBack()
        }
    }
}

//
//  SearchPresenter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import Promises

protocol SearchPresenterProtocol: class {
    var dataSource: SearchDataSource { get }
    func didSelectRow(atIndexPath indexPath: IndexPath)
    func closeButtonTapped()
    func searchButtonTapped(withText text: String)
    func textFieldTextChanged(_ text: String)
    func setSearchTextFieldHidden(_ hidden: Bool)
}

class SearchPresenter {
    weak var router: SearchRoutingLogic?
    let dataSource = SearchDataSource()
    private let viewController: SearchDisplayLogic
    private let interactor: SearchBusinessLogic
    private var searchLocationsWorkItem = DispatchWorkItem(block: {})
    
    init(viewController: SearchDisplayLogic, interactor: SearchBusinessLogic) {
        self.viewController = viewController
        self.interactor = interactor
    }
}

// MARK: - Presentation Logic
extension SearchPresenter: SearchPresenterProtocol {
    func didSelectRow(atIndexPath indexPath: IndexPath) {
        guard let location = dataSource.section(at: indexPath.section)?.row(at: indexPath.row)?.location else { return }
        viewController.showActivityIndicator(true)
        router?.requestNewWeatherData(forLocation: location)
    }
    
    func closeButtonTapped() {
        router?.navigate(to: .unwindBack)
    }
    
    func searchButtonTapped(withText text: String) {
        viewController.showActivityIndicator(true)
        searchLocationsWorkItem.cancel()
        interactor.getLocations(forText: text)
            .then(addLocationsAndReloadView)
            .catch(displayError)
    }
    
    func textFieldTextChanged(_ text: String) {
        dataSource.filterLocations(forText: text)
        viewController.reloadTableView(with: .reloadData)
        searchLocationsWorkItem.cancel()
        if !text.isEmpty {
            searchLocationsWorkItem = createDispatchWorkItem(withText: text)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: searchLocationsWorkItem)
        }
    }
    
    func setSearchTextFieldHidden(_ hidden: Bool) {
        router?.setSearchTextFieldHidden(hidden)
    }
}

private extension SearchPresenter {
    func createDispatchWorkItem(withText text: String) -> DispatchWorkItem {
        return DispatchWorkItem { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewController.showActivityIndicator(true)
            strongSelf.interactor.getLocations(forText: text)
                .then(strongSelf.addLocationsAndReloadView)
                .catch(strongSelf.displayError)
        }
    }
    
    func addLocationsAndReloadView(_ locations: [Location]) {
        dataSource.addLocations(locations)
        viewController.reloadTableView(with: .reloadData)
        viewController.showActivityIndicator(false)
    }
    
    func displayError(_ error: Error) {
        viewController.displayError(error)
    }
}

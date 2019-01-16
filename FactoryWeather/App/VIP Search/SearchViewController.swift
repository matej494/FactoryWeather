//
//  SearchViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import UIKit
import SnapKit
import Promises

protocol SearchDisplayLogic: class {
    func displayLocations(_ locations: [Location])
    func displayError(_ error: Error)
}

class SearchViewController: UIViewController {
    var interactor: SearchBusinessLogic?
    var router: SearchRoutingLogic?
    private let contentView: SearchContentView
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    private var dataSource = SearchDataSource()
    private var searchLocationsWorkItem = DispatchWorkItem(block: {})
    
    init(safeAreaInsets: UIEdgeInsets, delegate: SearchRouterDelegate?) {
        contentView = SearchContentView(bottomSafeAreaInset: safeAreaInsets.bottom).autolayoutView()
        super.init(nibName: nil, bundle: nil)
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.delegate = delegate
        self.interactor = interactor
        self.router = router
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Display Logic
extension SearchViewController: SearchDisplayLogic {
    func displayLocations(_ locations: [Location]) {
        dataSource.addLocations(locations)
        activityIndicatorView.stopAnimating()
        contentView.tableView.reloadData()
    }
    
    func displayError(_ error: Error) {
        let alert = UIAlertController(title: LocalizationKey.Alert.errorAlertTitle.localized(), message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.Alert.okActionTitle.localized(), style: .cancel, handler: nil))
        activityIndicatorView.stopAnimating()
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Delegate methods for animating transition
extension SearchViewController: SearchTransitionable {
    func dismissKeyboard() -> CGFloat {
        return contentView.dismissKeyboard()
    }
    
    func searchTextFieldIsHidden(_ isHidden: Bool) {
        router?.setSearchTextFieldHidden(isHidden)
    }
    
    func presentKeyboard() {
        contentView.presentKeyboard()
    }
}

// MARK: - TableView datasource mathods
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = dataSource.section(at: indexPath.section)?.row(at: indexPath.row) else {
            return UITableViewCell()
        }
        switch row {
        case .location(let viewModel, _):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.defaultReuseIdentifier, for: indexPath) as? SearchTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(withData: viewModel)
            return cell
        }
    }
}

// MARK: - TableView delegate methods
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = dataSource.section(at: indexPath.section)?.row(at: indexPath.row)?.location else { return }
        activityIndicatorView.startAnimating()
        router?.locationSelected(location)
    }
}

// MARK: - Private Methods
private extension SearchViewController {
    func setupViews() {
        view.backgroundColor = .none
        setupContentView()
        setupAcitivityIndicatorView()
    }
    
    func setupContentView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.defaultReuseIdentifier)
        contentView.didTapOnDismissButton = { [weak self] in self?.router?.dismiss() }
        contentView.didTapOnSearchButton = { [weak self] text in self?.searchButtonTapped(withText: text) }
        contentView.textFieldTextChanged = { [weak self] text in self?.textFieldTextChanged(text: text) }
        view.addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupAcitivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    func searchButtonTapped(withText text: String) {
        activityIndicatorView.startAnimating()
        searchLocationsWorkItem.cancel()
        interactor?.getLocations(forText: text)
    }
    
    func textFieldTextChanged(text: String) {
        dataSource.filterLocations(forText: text)
        contentView.tableView.reloadData()
        searchLocationsWorkItem.cancel()
        if !text.isEmpty {
            searchLocationsWorkItem = DispatchWorkItem { [weak self] in
                self?.activityIndicatorView.startAnimating()
                self?.interactor?.getLocations(forText: text)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: searchLocationsWorkItem)
        }
    }
}

//
//  SearchViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 18/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit
import Promises

class SearchViewController: UIViewController {
    var didSelectLocation: ((Weather, Location) -> Void)?
    var searchTextFieldIsHidden: ((Bool) -> Void)?
    private var locations = [Location]()
    private var filteredLocations = [Location]()
    private let searchView: SearchView
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    private var searchLocationsWorkItem = DispatchWorkItem(block: {})
    
    init(safeAreaInsets: UIEdgeInsets) {
        searchView = SearchView(bottomSafeAreaInset: safeAreaInsets.bottom).autolayoutView()
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchViewController: SearchTransitionable {
    func dismissKeyboard() -> CGFloat {
        return searchView.dismissKeyboard()
    }
    
    func searchTextFieldIsHidden(_ isHidden: Bool) {
        searchTextFieldIsHidden?(isHidden)
    }
    
    func presentKeyboard() {
        searchView.presentKeyboard()
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell
            else { return UITableViewCell() }
        cell.nameLabelText = filteredLocations[indexPath.row].fullName
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndicatorView.startAnimating()
        let location = filteredLocations[indexPath.row]
        DataManager.saveLocation(location)
        DarkSkyApiManager.getForecast(forLocation: location)
            .then { [weak self] weather in
                self?.didSelectLocation?(weather, location)
                self?.activityIndicatorView.stopAnimating()
                self?.dismiss(animated: true, completion: nil)
            }
            .catch {[weak self] error in
                let alert = UIAlertController(title: LocalizationKey.Alert.errorAlertTitle.localized(), message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.Alert.okActionTitle.localized(), style: .cancel, handler: nil))
                self?.activityIndicatorView.stopAnimating()
                self?.present(alert, animated: true, completion: nil)
            }
    }
}

private extension SearchViewController {
    func setupView() {
        view.backgroundColor = .none
        searchView.didTapOnDismissButton = { [weak self] in self?.dismiss(animated: true, completion: nil) }
        searchView.tableView.dataSource = self
        searchView.tableView.delegate = self
        setupTextFieldTextChanged()
        setupSearchButtonTapped()
        view.addSubview(searchView)
        searchView.snp.makeConstraints { $0.edges.equalToSuperview() }
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    func setupTextFieldTextChanged() {
        searchView.textFieldTextChanged = { [weak self] text in
            guard let strongSelf = self
                else { return }
            strongSelf.searchLocationsWorkItem.cancel()
            if !text.isEmpty {
                strongSelf.searchLocationsWorkItem = DispatchWorkItem(block: { [weak self] in
                    self?.getLocations(forText: text)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: strongSelf.searchLocationsWorkItem)
            }
            strongSelf.filterLocations(forText: text)
        }
    }
    
    func setupSearchButtonTapped() {
        searchView.didTapOnSearchButton = { [weak self] text in
            self?.activityIndicatorView.startAnimating()
            GeoNamesApiManager.getLocations(forText: text,
                                            success: { [weak self] locations in
                                                self?.insertNewLocations(locations)
                                                self?.filterLocations(forText: text)
                                                self?.activityIndicatorView.stopAnimating() },
                                            failure: { [weak self] error in
                                                print(error.localizedDescription)
                                                self?.activityIndicatorView.stopAnimating()
            })
        }
    }
    
    func insertNewLocations(_ newLocations: [Location]) {
        var tempLocations = [Location]()
        newLocations.forEach { location in
            if !locations.contains(where: { $0.latitude == location.latitude && $0.longitude == location.longitude }) {
                tempLocations.append(location)
            }
        }
        locations.insert(contentsOf: tempLocations, at: 0)
    }
    
    func filterLocations(forText text: String) {
        filteredLocations = locations.filter({ $0.fullName.lowercased().contains(text.lowercased()) })
        searchView.tableView.reloadData()
    }
    
    func getLocations(forText text: String) {
        activityIndicatorView.startAnimating()
        GeoNamesApiManager.getLocations(forText: text,
                                        success: { [weak self] locations in
                                            self?.insertNewLocations(locations)
                                            self?.filterLocations(forText: text)
                                            self?.activityIndicatorView.stopAnimating() },
                                        failure: { [weak self] error in
                                            print(error.localizedDescription)
                                            self?.activityIndicatorView.stopAnimating()
        })
    }
}

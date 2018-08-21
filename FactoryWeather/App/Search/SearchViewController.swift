//
//  SearchViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 18/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class SearchViewController: UIViewController {
    var didSelectLocation: ((Weather) -> Void)?
    private var locations = [Location]()
    private var filteredLocations = [Location]()
    private let searchView = SearchView.autolayoutView()
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        DarkSkyApiManager.getForecast(forLocation: filteredLocations[indexPath.row],
                                      success: { [weak self] weather in
                                        self?.didSelectLocation?(weather)
                                        self?.activityIndicatorView.stopAnimating()
                                        self?.dismiss(animated: true, completion: nil) },
                                      failure: { [weak self] error in
                                        let alert = UIAlertController(title: LocalizationKey.Alert.errorAlertTitle, message: error.localizedDescription, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: LocalizationKey.Alert.okActionTitle, style: .cancel, handler: nil))
                                        self?.activityIndicatorView.stopAnimating()
                                        self?.present(alert, animated: true, completion: nil) })
    }
}

private extension SearchViewController {
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

private extension SearchViewController {
    func setupView() {
        view.backgroundColor = .none
        searchView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchDown)
        searchView.tableView.dataSource = self
        searchView.tableView.delegate = self
        setupTextFieldTextChanged()
        setupSearchButtonTapped()
        view.addSubview(searchView)
        searchView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    func setupTextFieldTextChanged() {
        searchView.textFieldTextChanged = { [weak self] text in
            self?.filterLocations(forText: text)
        }
    }
    
    func setupSearchButtonTapped() {
        searchView.searchButtonTapped = { [weak self] text in
            self?.activityIndicatorView.startAnimating()
            GeoNamesApiManager.getLocations(forText: text,
                                            success: { [weak self] locations in
                                                self?.insertNewLocations(locations)
                                                self?.filterLocations(forText: text)
                                                self?.activityIndicatorView.stopAnimating() },
                                            failure: { [weak self] error in
                                                print(error.localizedDescription)
                                                self?.activityIndicatorView.stopAnimating() })
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
}

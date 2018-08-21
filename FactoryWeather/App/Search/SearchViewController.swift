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
    // NOTE: Dummy data. Will be raplaced when network is implemented
    private let locations = [Location(name: "London", country: "GB", latitude: 51.5074, longitude: 0.1278),
                             Location(name: "Osijek", country: "CRO", latitude: 45.5550, longitude: 18.6955),
                             Location(name: "East London", country: "SA", latitude: 33.0292, longitude: 27.8546),
                             Location(name: "New London", country: "US", latitude: 41.3557, longitude: 72.0995),
                             Location(name: "New York", country: "US", latitude: 40.7128, longitude: 74.0060)]
    private lazy var filteredLocations = [Location]()
    private let searchView = SearchView.autolayoutView()
    
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
        DarkSkyApiManager.getForecast(forLocation: filteredLocations[indexPath.row],
                                      success: { [weak self] weather in
                                        self?.didSelectLocation?(weather)
                                        self?.dismiss(animated: true, completion: nil) },
                                      failure: { [weak self] error in
                                        let alert = UIAlertController(title: LocalizationKey.Alert.errorAlertTitle, message: error.localizedDescription, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: LocalizationKey.Alert.okActionTitle, style: .cancel, handler: nil))
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
        searchView.didChangeTextInTextField = { [weak self] text in
            guard let strongSelf = self,
                let text = text
                else { return }
            strongSelf.filteredLocations = strongSelf.locations.filter({ $0.fullName.lowercased().contains(text.lowercased()) })
            strongSelf.searchView.tableView.reloadData()
        }
        view.addSubview(searchView)
        searchView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }    
}

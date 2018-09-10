//
//  SearchViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 18/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class SearchViewController: UIViewController {
    var searchTextFieldIsHidden: ((Bool) -> Void)?
    
    private let viewModel: SearchViewModel
    private let searchView: SearchView
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    
    init(viewModel: SearchViewModel, safeAreaInsets: UIEdgeInsets) {
        self.viewModel = viewModel
        searchView = SearchView(bottomSafeAreaInset: safeAreaInsets.bottom).autolayoutView()
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupCallbacks()
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
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell
            else { return UITableViewCell() }
        cell.updateProperties(viewModel: viewModel.cellViewModel(atIndexPath: indexPath))
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(withIndexPath: indexPath)
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
    
    func setupCallbacks() {
        viewModel.filteredLocations.bind { [weak self] _ in
            self?.searchView.tableView.reloadData()
        }
        viewModel.waitingResponse.bind { [weak self] isWaiting in
            if isWaiting {
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.activityIndicatorView.stopAnimating()
            }
        }
        viewModel.dismissViewController.bind { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupTextFieldTextChanged() {
        searchView.textFieldTextChanged = { [weak self] text in
            self?.viewModel.textFieldTextChanged(newValue: text)
        }
    }
    
    func setupSearchButtonTapped() {
        searchView.didTapOnSearchButton = { [weak self] text in
            self?.viewModel.getLocations(forText: text)
        }
    }
}

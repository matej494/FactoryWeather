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
    func reloadTableView(with option: TableRefresh)
    func displayError(_ error: Error)
    func showActivityIndicator(_ shouldShow: Bool)
}

class SearchViewController: UIViewController {
    weak var presenter: SearchPresenterProtocol?
    private let contentView: SearchContentView
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    
    init(safeAreaInsets: UIEdgeInsets) {
        contentView = SearchContentView(bottomSafeAreaInset: safeAreaInsets.bottom).autolayoutView()
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Display Logic
extension SearchViewController: SearchDisplayLogic {
    func reloadTableView(with option: TableRefresh) {
        let tableView = contentView.tableView
        switch option {
        case .reloadData:
            tableView.reloadData()
        case .reloadSections(let sections):
            tableView.reloadSections(sections, with: .automatic)
        case .reloadRows(let rows):
            tableView.reloadRows(at: rows, with: .automatic)
        }
    }
    
    func displayError(_ error: Error) {
        let alert = UIAlertController(title: LocalizationKey.Alert.errorAlertTitle.localized(), message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.Alert.okActionTitle.localized(), style: .cancel, handler: nil))
        activityIndicatorView.stopAnimating()
        present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator(_ shouldShow: Bool) {
        shouldShow ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
}

// MARK: - Delegate methods for animating transition
extension SearchViewController: SearchTransitionable {
    func dismissKeyboard() -> CGFloat {
        return contentView.dismissKeyboard()
    }
    
    func searchTextFieldIsHidden(_ isHidden: Bool) {
        presenter?.setSearchTextFieldHidden(isHidden)
    }
    
    func presentKeyboard() {
        contentView.presentKeyboard()
    }
}

// MARK: - TableView datasource mathods
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.dataSource.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.dataSource.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = presenter?.dataSource.section(at: indexPath.section)?.row(at: indexPath.row) else {
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
        presenter?.didSelectRow(atIndexPath: indexPath)
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
        contentView.didTapOnDismissButton = { [weak self] in self?.presenter?.closeButtonTapped() }
        contentView.didTapOnSearchButton = { [weak self] text in self?.presenter?.searchButtonTapped(withText: text) }
        contentView.textFieldTextChanged = { [weak self] text in self?.presenter?.textFieldTextChanged(text) }
        view.addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupAcitivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

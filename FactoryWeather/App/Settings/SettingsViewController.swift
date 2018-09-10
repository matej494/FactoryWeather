//
//  SettingsViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    private let settingsView = SettingsView.autolayoutView()
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupCallbacks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SettingsSection.locations.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell,
                let cellViewModel: LocationTableViewCell.ViewModel = viewModel.cellViewModel(atIndexPath: indexPath)
                else { return UITableViewCell() }
            cell.updateProperties(viewModel: cellViewModel)
            return cell
        } else if indexPath.section == SettingsSection.units.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UnitTableViewCell.identifier, for: indexPath) as? UnitTableViewCell,
                let cellViewModel: UnitTableViewCell.ViewModel = viewModel.cellViewModel(atIndexPath: indexPath)
                else { return UITableViewCell() }
            cell.updateProperties(viewModel: cellViewModel)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConditionsTableViewCell.identifier, for: indexPath) as? ConditionsTableViewCell,
                let cellViewModel: ConditionsTableViewCell.ViewModel = viewModel.cellViewModel(atIndexPath: indexPath)
                else { return UITableViewCell() }
            cell.updateProperties(viewModel: cellViewModel)
            return cell
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAtIndexPath(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .gothamRounded(type: .book, ofSize: 20)
        label.text = SettingsSection(rawValue: section)?.localizedName
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

private extension SettingsViewController {
    func setupView() {
        view.backgroundColor = .none
        settingsView.tableView.dataSource = self
        settingsView.tableView.delegate = self
        settingsView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchDown)
        view.addSubview(settingsView)
        settingsView.snp.makeConstraints { $0.edges.equalToSuperview() }
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    func setupCallbacks() {
        viewModel.locations.bind { [weak self] _ in
            self?.settingsView.tableView.reloadSections([SettingsSection.locations.rawValue], with: .automatic)
        }
        viewModel.settings.bind { [weak self] _ in
            self?.settingsView.tableView.reloadSections([SettingsSection.units.rawValue, SettingsSection.conditions.rawValue], with: .automatic)
        }
        viewModel.waitingResponse.bind { [weak self] isWaiting in
            if isWaiting {
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.activityIndicatorView.stopAnimating()
            }
        }
        viewModel.shouldDismissVC.bind { [weak self] shouldDismiss in
            self?.dismiss(animated: shouldDismiss, completion: nil)
        }
    }
    
    @objc func doneButtonTapped() {
        viewModel.doneButtonTapped()
    }
}

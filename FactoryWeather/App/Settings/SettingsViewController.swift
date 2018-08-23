//
//  SettingsViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class SettingsViewController: UIViewController {
    var settingsChanged: ((Location, Weather) -> Void)?
    private var selectedLocation: Location?
    private let oldLocation: Location
    private var locations = DataManager.getLocations()
    private var settings = DataManager.getSettings()
    private let settingsView = SettingsView.autolayoutView()
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    
    init(location: Location) {
        self.oldLocation = location
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allValuesCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SettingsSection.locations.rawValue {
            return min(SettingsSection.locations.count, locations.count)
        }
        guard let count = SettingsSection(rawValue: section)?.count
            else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SettingsSection.locations.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(text: locations[indexPath.row].fullName)
            cell.didTapOnButton = { [weak self] in
                guard let strongSelf = self
                    else { return }
                DataManager.deleteLocation(strongSelf.locations[indexPath.row])
                strongSelf.locations = DataManager.getLocations()
                tableView.reloadSections([indexPath.section], with: .none)
            }
            return cell
        } else if indexPath.section == SettingsSection.units.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UnitTableViewCell", for: indexPath) as? UnitTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(unitName: Unit(rawValue: indexPath.row)?.localizedName, isSelected: settings.unit == Unit(rawValue: indexPath.row))
            cell.didTapOnButton = { [weak self] in
                self?.settings.unit = Unit(rawValue: indexPath.row) ?? .metric
                tableView.reloadSections([indexPath.section], with: .none)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionsTableViewCell", for: indexPath) as? ConditionsTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(conditions: settings.conditions)
            cell.didTapOnButton = { [weak self] condition in
                self?.settings.conditions.toggle(condition: condition)
                tableView.reloadSections([indexPath.section], with: .none)
            }
            return cell
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SettingsSection.locations.rawValue {
            selectedLocation = locations[indexPath.row]
        }
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
        settingsView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    @objc func doneButtonTapped() {
        activityIndicatorView.startAnimating()
        guard selectedLocation != nil || settings != DataManager.getSettings()
            else { return dismiss(animated: true, completion: nil) }
        let location = selectedLocation ?? oldLocation
        DarkSkyApiManager.getForecast(forLocation: location,
                                      success: { [weak self] weather in
                                        guard let strongSelf = self
                                            else { return }
                                        DataManager.saveSettings(strongSelf.settings)
                                        strongSelf.settingsChanged?(location, weather)
                                        strongSelf.activityIndicatorView.stopAnimating()
                                        strongSelf.dismiss(animated: true, completion: nil) },
                                      failure: { [weak self] error in
                                        let alert = UIAlertController(title: LocalizationKey.Alert.errorAlertTitle.localized(), message: error.localizedDescription, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: LocalizationKey.Alert.stayHereActionTitle.localized(), style: .cancel, handler: nil))
                                        alert.addAction(UIAlertAction(title: LocalizationKey.Alert.goBackActionTitle.localized(), style: .default) { [weak self] action in
                                            self?.dismiss(animated: true, completion: nil)
                                        })
                                        self?.activityIndicatorView.stopAnimating()
                                        self?.present(alert, animated: true, completion: nil)
        })
    }
}

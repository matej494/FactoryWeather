//
//  SettingsViewModelImpl.swift
//  FactoryWeather
//
//  Created by Matej Korman on 07/09/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

class SettingsViewModelImpl: SettingsViewModel {
    private(set) var locations = Box<[Location]>(DataManager.getLocations())
    private(set) var settings = Box<Settings>(DataManager.getSettings())
    private(set) var weather = Box<Weather?>(nil)
    private(set) var waitingResponse = Box<Bool>(false)
    private(set) var selectedLocation = Box<Location?>(nil)
    private(set) var shouldDismissVC = Box<Bool>(false)
    private var oldLocation: Location
    
    init(oldLocation: Location) {
        self.oldLocation = oldLocation
    }
    
    func numberOfSections() -> Int {
        return SettingsSection.allValuesCount
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if section == SettingsSection.locations.rawValue {
            return min(SettingsSection.locations.count, locations.value.count)
        }
        return SettingsSection(rawValue: section)?.count ?? 0
    }
    
    func cellForRowAtIndexPath(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SettingsSection.locations.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell
                else { return UITableViewCell() }
            let viewModel = LocationTableViewCell.ViewModel(text: locations.value[indexPath.row].fullName,
                                                            didTapOnButton: { [weak self] in
                                                                guard let strongSelf = self
                                                                    else { return }
                                                                DataManager.deleteLocation(strongSelf.locations.value[indexPath.row])
                                                                strongSelf.locations.value = DataManager.getLocations()
            })
            cell.updateProperties(viewModel: viewModel)
            return cell
        } else if indexPath.section == SettingsSection.units.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UnitTableViewCell.identifier, for: indexPath) as? UnitTableViewCell
                else { return UITableViewCell() }
            let viewModel = UnitTableViewCell.ViewModel(unitName: Unit(rawValue: indexPath.row)?.localizedName,
                                                        buttonIsSelected: settings.value.unit == Unit(rawValue: indexPath.row),
                                                        didTapOnButton: { [weak self] in
                                                            self?.settings.value.unit = Unit(rawValue: indexPath.row) ?? .metric
            })
            cell.updateProperties(viewModel: viewModel)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConditionsTableViewCell.identifier, for: indexPath) as? ConditionsTableViewCell
                else { return UITableViewCell() }
            let viewModel = ConditionsTableViewCell.ViewModel(conditions: settings.value.conditions,
                                                              didTapOnButton: {[weak self] condition in
                                                                self?.settings.value.conditions.toggle(condition: condition)
            })
            cell.updateProperties(viewModel: viewModel)
            return cell
        }
    }
    
    func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
        if indexPath.section == SettingsSection.locations.rawValue {
            selectedLocation.value = locations.value[indexPath.row]
        }
    }
    
    func doneButtonTapped() {
        let oldSettings = DataManager.getSettings()
        guard selectedLocation.value != nil || settings.value != oldSettings
            else { return shouldDismissVC.value = true }
        waitingResponse.value = true
        if settings.value != oldSettings {
            DataManager.saveSettings(settings.value)
        }
        let location = selectedLocation.value ?? oldLocation
        DarkSkyApiManager.getForecast(forLocation: location,
                                      success: { [weak self] weather in
                                        self?.weather.value = weather
                                        self?.waitingResponse.value = false
                                        self?.shouldDismissVC.value = true },
                                      failure: { [weak self] error in
                                        print(error.localizedDescription)
                                        self?.waitingResponse.value = false
                                        self?.shouldDismissVC.value = true
        })
    }
}

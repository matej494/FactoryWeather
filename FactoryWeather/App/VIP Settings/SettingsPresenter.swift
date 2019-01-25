//
//  SettingsPresenter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import Promises

protocol SettingsPresenterProtocol: class {
    var dataSource: SettingsDataSource { get }
    func viewWillAppear()
    func didSelectRow(atIndexPath indexPath: IndexPath)
    func doneButtonTapped()
    func didTapButton(atIndexPath indexPath: IndexPath)
    func didTapButton(forCondition condition: Conditions, atIndexPath indexPath: IndexPath)
}

class SettingsPresenter {
    static private let MAX_NUMBER_OF_LOCATIONS = 3
    weak var router: SettingsRoutingLogic?
    let dataSource = SettingsDataSource()
    private let viewController: SettingsDisplayLogic
    private let interactor: SettingsBusinessLogic
    
    init(viewController: SettingsDisplayLogic, interactor: SettingsBusinessLogic) {
        self.viewController = viewController
        self.interactor = interactor
    }
}

extension SettingsPresenter: SettingsPresenterProtocol {
    func viewWillAppear() {
        all(interactor.getSavedLocations(), interactor.getSettings())
            .then { [weak self] locations, settings in
                let max3Locations = Array(locations[0...min(SettingsPresenter.MAX_NUMBER_OF_LOCATIONS - 1, locations.count)])
                self?.dataSource.setNewValues(locations: max3Locations, settings: settings)
                self?.viewController.reloadTableView(with: .reloadData)
            }
            .catch { print($0.localizedDescription) }
    }
    
    func didSelectRow(atIndexPath indexPath: IndexPath) {
        guard let section = dataSource.section(at: indexPath.section) else { return }
        switch section {
        case .locations:
            if let selectedLocation = dataSource.locations?[safe: indexPath.row] {
                dataSource.selectedLocation = selectedLocation
            }
        case .units, .conditions:
            break
        }
    }
    
    func doneButtonTapped() {
        interactor.getSettings()
            .then(saveSettingsIfChanged)
            .then(requestWeatherUpdateIfNeeded)
            .catch { print($0.localizedDescription) }
    }
    
    func didTapButton(atIndexPath indexPath: IndexPath) {
        guard let section = dataSource.section(at: indexPath.section) else { return }
        switch section {
        case .locations:
            if let location = dataSource.locations?[safe: indexPath.row] {
                interactor.deleteLocation(location)
                    .then { [weak self] _ in self?.viewController.reloadTableView(with: .reloadSections([indexPath.section])) }
                    .catch { print($0.localizedDescription) }
            }
        case .units:
            if var settings = dataSource.settings {
                settings.unit.toggle()
                dataSource.setSettings(settings: settings)
                viewController.reloadTableView(with: .reloadSections([indexPath.section]))
            }
        case .conditions:
            break
        }
    }
    
    func didTapButton(forCondition condition: Conditions, atIndexPath indexPath: IndexPath) {
        if var settings = dataSource.settings {
            settings.conditions.toggle(condition: condition)
            dataSource.setSettings(settings: settings)
            viewController.reloadTableView(with: .reloadSections([indexPath.section]))
        }
    }
}

private extension SettingsPresenter {
    /** Fulfills promise with true if settings changed and false if settings didn't change. */
    func saveSettingsIfChanged(_ oldSettings: Settings) -> Promise<Bool> {
        guard let settings = dataSource.settings else { return Promise(false) }
        if settings != oldSettings {
            return interactor.saveSettings(settings)
                .then { _ in return Promise(true) }
        } else {
            return Promise(false)
        }
    }
    
    /** Requests weather update if needed or dismisses scene if nothing changed. */
    func requestWeatherUpdateIfNeeded(_ settingsChanged: Bool) {
        if settingsChanged || dataSource.selectedLocation != nil {
            router?.requestNewWeatherData(selectedLocation: dataSource.selectedLocation)
        } else {
            router?.navigate(to: .unwindBack)
        }
    }
}

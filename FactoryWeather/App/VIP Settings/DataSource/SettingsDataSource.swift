//
//  SettingsDataSource.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

class SettingsDataSource: DataSourceProtocol {
    var sections = [SettingsSection]()
    var selectedLocation: Location?
    private (set) var locations: [Location]?
    private (set) var settings: Settings?
    
    init() {
        buildSections()
    }
}

extension SettingsDataSource {
    func setLocations(_ locations: [Location]) {
        self.locations = locations
        buildSections()
    }
    
    func setSettings(settings: Settings) {
        self.settings = settings
        buildSections()
    }
    
    func setNewValues(locations: [Location], settings: Settings) {
        self.locations = locations
        self.settings = settings
        buildSections()
    }
    
    func sectionIndex(forCase caseType: SettingsSection) -> Int? {
        return sections.firstIndex { $0 == caseType }
    }
}

private extension SettingsDataSource {
    func buildSections() {
        sections.removeAll()
        sections.append(createLocationsSection())
        sections.append(createUnitsSection())
        sections.append(createConditionsSection())
    }
    
    func createLocationsSection() -> SettingsSection {
        guard let locations = locations else {
            return SettingsSection.locations(rows: [])
        }
        return SettingsSection.locations(rows: locations.map { SettingsRow.locations($0.fullName) })
    }
    
    func createUnitsSection() -> SettingsSection {
        guard let settings = settings else {
            return SettingsSection.units(rows: [])
        }
        let rows = Unit.allCases.map { SettingsRow.units(UnitTableViewCell.ViewModel((unitName: $0.localizedName, isSelected: settings.unit == $0))) }
        return SettingsSection.units(rows: rows)
    }
    
    func createConditionsSection() -> SettingsSection {
        guard let settings = settings else {
            return SettingsSection.conditions(rows: [])
        }
        let conditionsRow = SettingsRow.conditions(settings.conditions)
        return SettingsSection.conditions(rows: [conditionsRow])
    }
}

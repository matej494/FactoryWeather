//
//  SearchDataSource.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

class SearchDataSource: DataSourceProtocol {
    var sections = [SearchSection]()
    private var locations = [Location]()
    private var filterText: String?
}

extension SearchDataSource {
    func addLocations(_ locations: [Location]) {
        locations.reversed().forEach { location in
            if !self.locations.contains(where: { $0 == location }) {
                self.locations.insert(location, at: 0)
            }
        }
        buildSections(forText: filterText)
    }
    
    func filterLocations(forText text: String) {
        filterText = text
        buildSections(forText: text)
    }
}

private extension SearchDataSource {
    func buildSections(forText text: String?) {
        sections.removeAll()
        var rows = [SearchRow]()
        if let text = text, !text.isEmpty {
            let filteredLocations = locations.filter { $0.fullName.lowercased().contains(text.lowercased()) }
            rows = createRows(withLocations: filteredLocations)
        } else {
            rows = createRows(withLocations: locations)
        }
        sections.append(SearchSection.location(rows: rows))
    }
    
    func createRows(withLocations locations: [Location]) -> [SearchRow] {
        return locations.map { location in
            let viewModel = SearchTableViewCell.ViewModel(firstLetter: String(location.fullName.first ?? Character("")), title: location.fullName)
            return SearchRow.location(viewModel, location: location)
        }
    }
}

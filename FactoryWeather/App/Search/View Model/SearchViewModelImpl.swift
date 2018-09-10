//
//  SearchViewModelImpl.swift
//  FactoryWeather
//
//  Created by Matej Korman on 03/09/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

class SearchViewModelImpl: SearchViewModel {
    private(set) var filteredLocations = Box([Location]())
    private(set) var weather = Box<Weather?>(nil)
    private(set) var waitingResponse = Box<Bool>(false)
    private(set) var selectedLocation = Box<Location?>(nil)
    private(set) var dismissViewController = Box<Bool>(false)

    private var locations = [Location]()
    private var searchLocationsWorkItem = DispatchWorkItem(block: {})
    
    func getLocations(forText text: String) {
        waitingResponse.value = true
        GeoNamesApiManager.getLocations(forText: text,
                                        success: { [weak self] locations in
                                            self?.insertNewLocations(locations)
                                            self?.filterLocations(forText: text)
                                            self?.waitingResponse.value = false },
                                        failure: { [weak self] error in
                                            print(error.localizedDescription)
                                            self?.waitingResponse.value = false
        })
    }
    
    func textFieldTextChanged(newValue text: String) {
        searchLocationsWorkItem.cancel()
        if !text.isEmpty {
            searchLocationsWorkItem = DispatchWorkItem(block: { [weak self] in
                self?.getLocations(forText: text)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: searchLocationsWorkItem)
        }
        filterLocations(forText: text)
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return filteredLocations.value.count
    }
    
    func cellViewModel(atIndexPath indexPath: IndexPath) -> SearchTableViewCell.ViewModel {
        let viewModel = SearchTableViewCell.ViewModel(filteredLocations.value[indexPath.row].fullName)
        return viewModel
    }
    
    func didSelectRow(withIndexPath indexPath: IndexPath) {
        waitingResponse.value = true
        let location = filteredLocations.value[indexPath.row]
        selectedLocation.value = location
        DataManager.saveLocation(location)
        DarkSkyApiManager.getWeather(forLocation: location,
                                      success: { [weak self] weather in
                                        self?.weather.value = weather
                                        self?.waitingResponse.value = false
                                        self?.dismissViewController.value = true },
                                      failure: { [weak self] error in
                                        print(error.localizedDescription)
                                        self?.waitingResponse.value = false
                                        self?.dismissViewController.value = true
        })
    }
}

private extension SearchViewModelImpl {
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
        filteredLocations.value = locations.filter({ $0.fullName.lowercased().contains(text.lowercased()) })
    }
}

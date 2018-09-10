//
//  SearchViewModel.swift
//  FactoryWeather
//
//  Created by Matej Korman on 04/09/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

protocol SearchViewModel {
    var filteredLocations: Box<[Location]> { get }
    var weather: Box<Weather?> { get }
    var waitingResponse: Box<Bool> { get }
    var selectedLocation: Location? { get }

    func getLocations(forText text: String)
    func textFieldTextChanged(newValue text: String)
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellViewModel(atIndexPath indexPath: IndexPath) -> SearchTableViewCell.ViewModel
    func didSelectRow(withIndexPath indexPath: IndexPath)
}

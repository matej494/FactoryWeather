//
//  SettingsViewModel.swift
//  FactoryWeather
//
//  Created by Matej Korman on 07/09/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

protocol SettingsViewModel {
    var locations: Box<[Location]> { get }
    var settings: Box<Settings> { get }
    var weather: Box<Weather?> { get }
    var waitingResponse: Box<Bool> { get }
    var selectedLocation: Box<Location?> { get }
    var shouldDismissVC: Box<Bool> { get }
    
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellForRowAtIndexPath(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func didSelectRowAtIndexPath(_ indexPath: IndexPath)
    func doneButtonTapped() 
}

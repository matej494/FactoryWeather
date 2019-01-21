//
//  SavedLocationsWorker.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import Promises

class SavedLocationsWorker {
    func getSavedLocations() -> Promise<[Location]> {
        return DataManager.getLocations()
    }
    
    func deleteLocation(_ location: Location) -> Promise<Bool> {
        return DataManager.deleteLocation(location)
    }
}

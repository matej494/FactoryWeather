//
//  SavedLocationsWorker.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

class SavedLocationsWorker {
    //TODO: Implement promises
    func getSavedLocations() -> [Location] {
        return DataManager.getLocations()
    }
    
    func deleteLocation(_ location: Location) {
        DataManager.deleteLocation(location)
    }
}

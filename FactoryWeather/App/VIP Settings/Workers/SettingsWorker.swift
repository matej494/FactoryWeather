//
//  SettingsWorker.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

class SettingsWorker {
    func saveSettings(_ settings: Settings) {
        DataManager.saveSettings(settings)
    }
    
    //TODO: Implement promises
    func getSettings() -> Settings {
        return DataManager.getSettings()
    }
}

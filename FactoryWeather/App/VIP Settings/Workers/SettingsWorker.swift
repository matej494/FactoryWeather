//
//  SettingsWorker.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation
import Promises

class SettingsWorker {
    func saveSettings(_ settings: Settings) -> Promise<Bool> {
        return DataManager.saveSettings(settings)
    }
    
    func getSettings() -> Promise<Settings> {
        return DataManager.getSettings()
    }
}

//
//  DarkSkyApiManagerError.swift
//  FactoryWeather
//
//  Created by Matej Korman on 17/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

enum NetworkManagerError: LocalizedError {
    case urlCreationFailure
    case dataUnwrappingFailure
    case parsingDataFailure
    case generic(Error)
    
    var errorDescription: String? {
        switch self {
        case .urlCreationFailure:
            return LocalizationKey.DarkSkyApiManagerError.urlCreationFailure.localized()
        case .dataUnwrappingFailure:
            return LocalizationKey.DarkSkyApiManagerError.dataUnwrappingFailure.localized()
        case .parsingDataFailure:
            return LocalizationKey.DarkSkyApiManagerError.parsingDataFailure.localized()
        case .generic(let error):
            return error.localizedDescription
        }
    }
}

//
//  DarkSkyApiManagerError.swift
//  FactoryWeather
//
//  Created by Matej Korman on 17/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

enum DarkSkyApiManagerError: LocalizedError {
    case urlCreationFailure
    case dataUnwrapingFailure
    case parsingDataFailure
    case generic(Error)
    
    var errorDescription: String? {
        switch self {
        case .urlCreationFailure:
            return "Url creation failure."   // TODO: Localize
        case .dataUnwrapingFailure:
            return "Data unwraping failure."    // TODO: Localize
        case .parsingDataFailure:
            return "Parsing data failure."  // TODO: Localize
        case .generic(let error):
            return error.localizedDescription
        }
    }
}

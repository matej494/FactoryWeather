//
//  LocalizationKey.swift
//  FactoryWeather
//
//  Created by Matej Korman on 18/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct LocalizationKey {
    struct Home {
        static let lowTemperatureDescriptionLabel = "home_low_temperature_description_label"
        static let highTemperatureDescriptionLabel = "home_high_temperature_description_label"
    }
    
    struct Common {
        static let searchTextFieldPlaceholder = "search_text_field_placeholder"
    }
    
    struct DarkSkyApiManagerError {
        static let urlCreationFailure = "network_manager_url_creation_failure"
        static let dataUnwrappingFailure = "network_manager_data_unwrapping_failure"
        static let parsingDataFailure = "network_manager_parsing_data_failure"
    }
}

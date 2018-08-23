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

    struct Alert {
        static let errorAlertTitle = "error_alert_title"
        static let okActionTitle = "ok_action_title"
        static let stayHereActionTitle = "stay_here_action_title"
        static let goBackActionTitle = "go_back_action_title"
    }
    
    struct Settings {
        static let locationTableViewHeader = "settings_location_table_view_header"
        static let unitTableViewHeader = "settings_unit_table_view_header"
        static let conditionsTableViewHeader = "settings_conditions_table_view_header"
        static let metricLabel = "settings_metric_label"
        static let imperialLabel = "settings_imperial_label"
        static let doneButtonTitle = "settings_done_button_title"
    }
}

//
//  SearchRow.swift
//  FactoryWeather
//
//  Created by Matej Korman on 15/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

enum SearchRow {
    case location(SearchTableViewCell.ViewModel, location: Location)
    
    var location: Location {
        switch self {
            case .location(_, let location):
                return location
        }
    }
}

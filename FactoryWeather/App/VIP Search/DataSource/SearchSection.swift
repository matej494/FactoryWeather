//
//  SearchSection.swift
//  FactoryWeather
//
//  Created by Matej Korman on 15/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

enum SearchSection: SectionProtocol {
    case location(rows: [SearchRow])
    
    var rows: [SearchRow] {
        switch self {
        case .location(let rows):
            return rows
        }
    }
}

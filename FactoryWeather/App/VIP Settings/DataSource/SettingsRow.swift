//
//  SettingsRow.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

enum SettingsRow {
    case locations(LocationTableViewCell.ViewModel)
    case units(UnitTableViewCell.ViewModel)
    case conditions(ConditionsTableViewCell.ViewModel)
}

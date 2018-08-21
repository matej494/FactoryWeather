//
//  DarkSkyApi.swift
//  FactoryWeather
//
//  Created by Matej Korman on 17/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct DarkSkyApi {
    static let url = URL(string: "https://api.darksky.net/forecast")?.appendingPathComponent(DarkSkyApi.key)
    static let excludingProperties = URLQueryItem(name: "exclude", value: "minutely,hourly,flags,alerts")
    static private let key = "6771e4c9c0d9d4ca28ceb73f7c575e95"
    
    static func locationParameter(_ location: Location) -> String { return "\(location.latitude),\(location.longitude)" }
    static func timeParameter(_ time: TimeInterval) -> String { return ",\(Int(time))" }
}

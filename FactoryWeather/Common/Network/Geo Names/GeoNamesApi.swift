//
//  GeoNamesApi.swift
//  FactoryWeather
//
//  Created by Matej Korman on 20/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

struct GeoNamesApi {
    static let url = URL(string: "http://api.geonames.org")?.appendingPathComponent("searchJSON")
    static let shortStyle = URLQueryItem(name: "style", value: "SHORT")
    static let orderByRelevance = URLQueryItem(name: "orderby", value: "relevance")
    static let username = URLQueryItem(name: "username", value: "matej_ios")
    
    static func maxNumberOfRows(_ number: Int) -> URLQueryItem {
        return URLQueryItem(name: "maxRows", value: String(number))
    }
    
    static func query(forText text: String) -> URLQueryItem {
        return URLQueryItem(name: "name", value: text)
    }
}

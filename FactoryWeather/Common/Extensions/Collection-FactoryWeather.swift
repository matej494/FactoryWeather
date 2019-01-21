//
//  Collection-FactoryWeather.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

public extension Collection {
	subscript (safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
	
	func count(where clause: (Element) -> Bool) -> Int {
		return filter(clause).count
	}
}

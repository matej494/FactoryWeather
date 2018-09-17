//
//  HomeViewModel.swift
//  FactoryWeather
//
//  Created by Matej Korman on 10/09/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

protocol HomeViewModel {
    var waitingResponse: Box<Bool> { get }
    var weather: Box<Weather?> { get }
    var location: Location { get }
    var settings: Settings { get }
    
    func dataChanged<T>(_ data: T)
}

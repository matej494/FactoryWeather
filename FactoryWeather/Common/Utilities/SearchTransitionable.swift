//
//  SearchTransitionable.swift
//  FactoryWeather
//
//  Created by Matej Korman on 28/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

protocol SearchTransitionable {
    func dismissKeyboard() -> CGFloat
    func searchTextFieldIsHidden(_ isHidden: Bool)
    func presentKeyboard()
}

//
//  UIFont-FactoryWeather.swift
//  FactoryWeather
//
//  Created by Matej Korman on 17/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

extension UIFont {
    static func gothamRounded(type: GothamFont, ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: type.rawValue, size: size)
    }
}

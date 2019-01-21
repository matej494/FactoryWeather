//
//  ReusableView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 10/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import UIKit

public protocol ReusableView {
    static var defaultReuseIdentifier: String { get }
}

extension UIView: ReusableView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

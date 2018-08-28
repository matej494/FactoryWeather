//
//  SearchPresentable.swift
//  FactoryWeather
//
//  Created by Matej Korman on 27/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

protocol SearchPresentable {
    var safeAreaLayoutGuideFrame: CGRect { get }
    func searchTextFieldIsHidden(_ isHidden: Bool)
}

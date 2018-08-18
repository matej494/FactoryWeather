//
//  String-FactoryWeather.swift
//  FactoryWeather
//
//  Created by Matej Korman on 18/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import Foundation

extension String {
    func localized(_ args: CVarArg...) -> String {
        guard !self.isEmpty else { return self }
        let localizedString = NSLocalizedString(self, comment: "")
        return withVaList(args) { NSString(format: localizedString, locale: Locale.current, arguments: $0) as String }
    }
}

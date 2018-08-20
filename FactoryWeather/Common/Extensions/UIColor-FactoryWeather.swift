//
//  UIColor-FactoryWeather.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
    
    static var daySkyTop: UIColor {
        return UIColor(red: 89, green: 183, blue: 224)
    }
    
    static var daySkyBottom: UIColor {
        return UIColor(red: 216, green: 216, blue: 216)
    }
    
    static var rainSkyTop: UIColor {
        return UIColor(red: 21, green: 88, blue: 123)
    }
    
    static var rainSkyBottom: UIColor {
        return UIColor(red: 74, green: 117, blue: 162)
    }
    
    static var snowSkyTop: UIColor {
        return UIColor(red: 11, green: 58, blue: 78)
    }
    
    static var snowSkyBottom: UIColor {
        return UIColor(red: 128, green: 213, blue: 243)
    }
    
    static var nightSkyTop: UIColor {
        return UIColor(red: 4, green: 70, blue: 99)
    }
    
    static var nightSkyBottom: UIColor {
        return UIColor(red: 35, green: 72, blue: 128)
    }
    
    static var fogSkyTop: UIColor {
        return UIColor(red: 171, green: 214, blue: 233)
    }
    
    static var fogSkyBottom: UIColor {
        return daySkyBottom
    }
    
    static var factoryGreen: UIColor {
        return UIColor(red: 109, green: 161, blue: 51)
    }
    
    static var factoryYellow: UIColor {
        return UIColor(red: 248, green: 231, blue: 28)
    }
    
    static var factoryGray: UIColor {
        return UIColor(red: 216, green: 216, blue: 216)
    }
    
    static var factoryDeepGreen: UIColor {
        return UIColor(red: 65, green: 117, blue: 5)
    }
    
    static var factoryLightBlue: UIColor {
        return UIColor(red: 208, green: 223, blue: 239)
    }
    
    static var factoryPaleCyan: UIColor {
        return UIColor(red: 171, green: 177, blue: 208)
    }
}

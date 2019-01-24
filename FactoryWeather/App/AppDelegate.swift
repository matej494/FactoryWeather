//
//  AppDelegate.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow(frame: UIScreen.main.bounds)
    var homeRouter: HomeRouter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("UserData.realm").path
        if !FileManager.default.fileExists(atPath: (documentsURL)) {
            DataManager.saveSettings(Settings(unit: .metric, conditions: Conditions.all))
        }
        homeRouter = HomeRouter(delegate: nil)
        window.rootViewController = homeRouter?.buildScene()
        window.makeKeyAndVisible()
        return true
    }
}

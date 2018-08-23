//
//  DataManager.swift
//  FactoryWeather
//
//  Created by Matej Korman on 22/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//
// swiftlint:disable force_try

import Foundation
import RealmSwift

class DataManager {
    private static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("UserData.realm")
    private static let realm = try! Realm(fileURL: documentsURL)
    
    static func getSettings() -> Settings {
        guard let data = realm.objects(RealmSettings.self).first
            else { return Settings(realmSettings: RealmSettings()) }
        return Settings(realmSettings: data)
    }
    
    static func saveSettings(_ settings: Settings) {
        let realmSettings = RealmSettings(settings: settings)
        let oldRealmSettings = realm.objects(RealmSettings.self)
        do {
            try realm.write {
                self.realm.delete(oldRealmSettings)
                self.realm.add(realmSettings)
            }
        } catch {
            print("Error saving settings, \(error)")
        }
    }
    
    static func getLocations() -> [Location] {
        let realmLocations = realm.objects(RealmLocation.self).reversed()
        let locations = realmLocations.map({ Location(realmLocation: $0) })
        return Array(locations)
    }
    
    static func saveLocation(_ location: Location) {
        let realmLocation = RealmLocation(location: location)
        let oldRealmLocation = realm.objects(RealmLocation.self).filter({ $0.compare(with: location) }).first
        do {
            try realm.write {
                if let location = oldRealmLocation {
                    self.realm.delete(location)
                }
                self.realm.add(realmLocation)
            }
        } catch {
            print("Error saving location, \(error)")
        }
    }
    
    static func deleteLocation(_ location: Location) {
        guard let realmLocation = realm.objects(RealmLocation.self).filter({ $0.compare(with: location) }).first
            else { return }
        do {
            try realm.write { self.realm.delete(realmLocation) }
        } catch {
            print("Error deleting location, \(error)")
        }
    }
}

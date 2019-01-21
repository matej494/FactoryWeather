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
import Promises

class DataManager {
    private static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("UserData.realm")
    private static let realm = try! Realm(fileURL: documentsURL)
    
    static func getSettings() -> Promise<Settings> {
        guard let data = realm.objects(RealmSettings.self).first
            else { return Promise(Settings(realmSettings: RealmSettings())) }
        return Promise(Settings(realmSettings: data))
    }
    
    static func saveSettings(_ settings: Settings) -> Promise<Bool> {
        return Promise { fulfill, reject in
            let realmSettings = RealmSettings(settings: settings)
            let oldRealmSettings = realm.objects(RealmSettings.self)
            do {
                try realm.write {
                    self.realm.delete(oldRealmSettings)
                    self.realm.add(realmSettings)
                }
                fulfill(true)
            } catch {
                print("Error saving settings, \(error)")
                reject(error)
            }
        }
    }
    
    static func getLocations() -> Promise<[Location]> {
        let realmLocations = realm.objects(RealmLocation.self).reversed()
        let locations = realmLocations.map({ Location(realmLocation: $0) })
        return Promise(Array(locations))
    }
    
    static func saveLocation(_ location: Location) -> Promise<Bool> {
        return Promise { fulfill, reject in
            let realmLocation = RealmLocation(location: location)
            let oldRealmLocation = realm.objects(RealmLocation.self).filter({ $0.compare(with: location) }).first
            do {
                try realm.write {
                    if let location = oldRealmLocation {
                        self.realm.delete(location)
                    }
                    self.realm.add(realmLocation)
                }
                fulfill(true)
            } catch {
                print("Error saving location, \(error)")
                reject(error)
            }
        }
    }
    
    static func deleteLocation(_ location: Location) -> Promise<Bool> {
        return Promise { fulfill, reject in
            guard let realmLocation = realm.objects(RealmLocation.self).filter({ $0.compare(with: location) }).first
                else { return fulfill(false) }
            do {
                try realm.write { self.realm.delete(realmLocation) }
                fulfill(true)
            } catch {
                print("Error deleting location, \(error)")
                reject(error)
            }
        }
    }
}

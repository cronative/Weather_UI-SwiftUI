//
//  RealmCore.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation
import RealmSwift

protocol DatabaseConfiguration {
    static var isFirstTime: Bool { get set }
    static var isFileProtectionRemoved: Bool { get set }

    static func realmConfig() -> Realm.Configuration
    static func realmInstance() -> Realm
    static func deleteRealmFiles(atURL realmURL: URL)
}

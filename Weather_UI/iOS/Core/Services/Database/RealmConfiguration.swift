//
//  RealmFunctionManager.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation
import RealmSwift

class RealmConfiguration: DatabaseConfiguration {
    
    // MARK: - Variables
    static let currentVersion: UInt64 = 1
    static var isFirstTime = true
    static var isFileProtectionRemoved = false
    
    
    // MARK: - Functions
    class func realmConfig() -> Realm.Configuration {
        
        return Realm.Configuration(schemaVersion: currentVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
          
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: { (totalBytes, usedBytes) -> Bool in
            return true
        })
    }
    
    class func realmInstance() -> Realm {
        do {
            if isFirstTime {
                let realm = try Realm(configuration: realmConfig())
                isFirstTime = false
                realm.invalidate()
            }
            
            let newRealm = try Realm(configuration: realmConfig())
            
            //Remove file protection only once per session
            if !isFileProtectionRemoved {
                do {
                    // Get our Realm file's parent directory
                    let folderPath = newRealm.configuration.fileURL!.deletingLastPathComponent().path
                    
                    // Disable file protection for this directory
                    try FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.none], ofItemAtPath: folderPath)
                    
                    isFileProtectionRemoved = true
                } catch let error {
                }
            }
            
            return newRealm
        } catch {
            if isFirstTime {
                deleteRealmFiles(atURL: Realm.Configuration.defaultConfiguration.fileURL!)
            }
            
            return try! Realm(configuration: realmConfig())
        }
    }
    
    class func deleteRealmFiles(atURL realmURL: URL) {
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for path in realmURLs {
            try? FileManager.default.removeItem(at: path)
        }
    }
}

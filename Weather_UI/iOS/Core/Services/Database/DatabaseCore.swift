//
//  RealmManager.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation
import RealmSwift

typealias RealmSortDescriptor = RealmSwift.SortDescriptor

protocol DatabaseCore {
    
    // MARK: - Variables
    var dbConfiguration: DatabaseConfiguration.Type { get }
    
    // MARK: - Functions
    func write<T: Object>(_ object: T?, block: @escaping ((Realm, T?) -> Void))
    func update<T: Object>(_ object: T, block: @escaping ((T) -> Void))
    
    func add(_ object: Object, updatesAllowed update: Bool)
    func add<S: Sequence>(_ objects: S, updatesAllowed update: Bool) where S.Iterator.Element: Object
    
    func get<R: Object>(fromEntity entityClass : R.Type, withPredicate predicate: NSPredicate?, sortedByKey sortKey: String?, inAscending isAscending: Bool) -> Results<R>
    func get<R: Object>(fromEntity entityClass : R.Type, withPredicate predicate: NSPredicate?, sortProperties: [RealmSortDescriptor]) -> Results<R>
    
    func getFirst<R: Object>(fromEntity entity : R.Type, withPredicate predicate: NSPredicate? , sortedByKey sortKey: String?, inAscending isAscending: Bool) -> R?
    func getObject(fromData dataObject: Data?) -> AnyObject?
    func getData(fromObj objValue: AnyObject?) -> Data?
    
    func delete(_ object: Object)
    func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object
    func delete(fromEntity entity: Object.Type, withPredicate predicate: NSPredicate?)
    func delete(fromEntity entity: Object.Type, withPrimaryKey primaryKey: String)
    
    func deleteAllData()
    
    func copy<R: Object>(object: R) -> R
    
    func deleteRealmFiles(atURL realmURL: URL)
}


extension DatabaseCore {
    
    // MARK: - Variables
    var dbConfiguration: DatabaseConfiguration.Type {
        return RealmConfiguration.self
    }
    
    // MARK: - Functions
    func write<T: Object>(_ object: T? = nil, block: @escaping ((Realm, T?) -> Void)) {
        
        var objectRef : ThreadSafeReference<T>? = nil
        
        //Check if object is not nil, and it is a Realm Managed Object. Convert it to a thread safe reference.
        if let object = object, object.realm != nil, !object.isInvalidated {
            objectRef = ThreadSafeReference(to: object)
        }
        
        DispatchQueue.init(label: "Realm").sync {
            autoreleasepool {
                let currentRealm =  dbConfiguration.realmInstance()
                var newObject : T?
                
                //If ObjectRef is not nil, it means we have to resolve the thread safe object back to realm managed object. Otherwise newObject is the original object.
                if let objectRef = objectRef {
                    guard let resolvedObject = currentRealm.resolve(objectRef) else {
                        return
                    }
                    newObject = resolvedObject
                } else {
                    newObject = object
                }
                
                if currentRealm.isInWriteTransaction {
                    return
                } else {
                    do {
                        try currentRealm.write {
                            block(currentRealm, newObject)
                        }
                    } catch let error {
                        return
                    }
                }
            }
        }
    }
    
    func update<T: Object>(_ object: T, block: @escaping ((T) -> Void)) {
        guard !object.isInvalidated else {
            return
        }
        
        write(object) { (_, newObject) in
            guard let newObject = newObject, !newObject.isInvalidated else {
                return
            }
            block(newObject)
        }
    }
    
    func add(_ object: Object, updatesAllowed update: Bool = true) {
        var updatePolicy: Realm.UpdatePolicy = .all
        if !update {
            updatePolicy = .error
        }
        
        write { (realmInstance, _) in
            realmInstance.add(object, update: updatePolicy)
        }
    }
    
    func add<S: Sequence>(_ objects: S, updatesAllowed update: Bool = true) where S.Iterator.Element: Object {
        var updatePolicy: Realm.UpdatePolicy = .all
        if !update {
            updatePolicy = .error
        }
        
        write { (realmInstance, _) in
            realmInstance.add(objects, update: updatePolicy)
        }
    }
    
    func get<R: Object>(fromEntity entity : R.Type, withPredicate predicate: NSPredicate? = nil, sortedByKey sortKey: String? = nil, inAscending isAscending: Bool = true) -> Results<R> {
        var objects = dbConfiguration.realmInstance().objects(entity)
        if predicate != nil {
            objects = objects.filter(predicate!)
        }
        if sortKey != nil {
            objects = objects.sorted(byKeyPath: sortKey!, ascending: isAscending)
        }
        
        return objects
    }
    
    func get<R: Object>(fromEntity entity : R.Type, withPredicate predicate: NSPredicate? = nil, sortProperties: [RealmSortDescriptor]) -> Results<R> {
        var objects = dbConfiguration.realmInstance().objects(entity)
        if predicate != nil {
            objects = objects.filter(predicate!)
        }
        if !sortProperties.isEmpty {
            objects = objects.sorted(by: sortProperties)
        }
        
        return objects
    }
    
    func get<R: Object>(fromEntity entity : R.Type, withPrimaryKey primaryKey: String) -> R? {
        return dbConfiguration.realmInstance().object(ofType: entity, forPrimaryKey: primaryKey as AnyObject)
    }
    
    func getSafe<R: Object>(fromEntity entityClass : R.Type, withPredicate predicate: NSPredicate? = nil, sortedByKey sortKey: String? = nil, inAscending isAscending: Bool = true) -> Results<R>? {
        let objects = get(fromEntity: entityClass, withPredicate: predicate, sortedByKey: sortKey, inAscending: isAscending)
        return objects.isInvalidated ? nil : objects
    }
    
    func getFirst<R: Object>(fromEntity entity : R.Type, withPredicate predicate: NSPredicate? = nil, sortedByKey sortKey: String? = nil, inAscending isAscending: Bool = true) -> R? {
        var objects = dbConfiguration.realmInstance().objects(entity) as Results<R>
        if predicate != nil {
            objects = objects.filter(predicate!)
        }
        if sortKey != nil {
            objects = objects.sorted(byKeyPath: sortKey!, ascending: isAscending)
        }
        return objects.first
    }
    
    func getObject(fromData dataObject: Data?) -> AnyObject?  {
        if dataObject == nil {
            return nil
        }
        do {
            let dict = try JSONSerialization.jsonObject(with: dataObject!, options: []) as AnyObject
            return dict
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getData(fromObj objValue: AnyObject?) -> Data? {
        if objValue == nil {
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: objValue!, options: [])
            return data
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func delete(_ object: Object) {
        write(object) { (realmInstance, newObject) in
            guard let newObject = newObject, !newObject.isInvalidated else {
                return
            }
            realmInstance.delete(newObject)
        }
    }
    
    func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        write { (realmInstance, _) in
            realmInstance.delete(objects)
        }
    }
    
    func delete(fromEntity entity: Object.Type, withPredicate predicate: NSPredicate? = nil) {
        delete(get(fromEntity: entity, withPredicate: predicate))
    }
    
    func delete(fromEntity entity: Object.Type, withPrimaryKey primaryKey: String) {
        if let object = get(fromEntity: entity, withPrimaryKey: primaryKey) {
            delete(object)
        }
    }
    
    func deleteAllData() {
        write { (realmInstance, _) in
            realmInstance.deleteAll()
        }
    }
    
    func deleteRealmFiles(atURL realmURL: URL) {
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
    
    
    func copy<R: Object>(object: R) -> R {
        let properties = object.objectSchema.properties.map { $0.name }
        
        let newObject = R()
        
        for prop in properties {
            newObject[prop] = object[prop]
        }
        
        return newObject
    }
}

//
//  RealmStorageContext.swift
//  NPS Browser
//
//  Created by JK3Y on 8/11/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import RealmSwift

/*
 Config storage options
 */
public enum ConfigurationType {
    case basic(url: String?)
    case inMemory(identifier: String?)
    
    var associated: String? {
        get {
            switch self {
            case .basic(let url): return url
            case .inMemory(let identifier): return identifier
            }
        }
    }
}

class RealmStorageContext: StorageContext {
    var realm: Realm?
    
    required init(configuration: ConfigurationType = .basic(url: nil)) throws {
        var rmConfig = Realm.Configuration()
        rmConfig.readOnly = true
        
        switch configuration {
        case .basic:
            rmConfig = Realm.Configuration.defaultConfiguration
            if let url = configuration.associated {
                rmConfig.fileURL = URL(string: url)
            }
        case .inMemory:
            rmConfig = Realm.Configuration()
            if let identifier = configuration.associated {
                rmConfig.inMemoryIdentifier = identifier
            } else {
                throw NSError()
            }
        }
        try self.realm = Realm(configuration: rmConfig)
    }
    
    public func safeWrite(_ block: (() throws -> Void)) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        if realm.isInWriteTransaction {
            try block()
        } else {
            try realm.write(block)
        }
    }
}

// MARK: Realm Storage Context + CRUD Operations
extension RealmStorageContext {
    func create<T>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws where T : Storable {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
          let newObject = realm.create(model as! Object.Type, value: [], update: Realm.UpdatePolicy.all) as! T
            completion(newObject)
        }
    }
    
    func save(object: Storable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.add(object as! Object)
        }
    }
    
    func update(block: @escaping () -> ()) throws {
        try self.safeWrite {
            block()
        }
    }
}

extension RealmStorageContext {
    func delete(object: Storable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.delete(object as! Object)
        }
    }
    
    func deleteAll<T: Storable>(_ model: T.Type) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            let objects = realm.objects(model as! Object.Type)
            for object in objects {
                realm.delete(object)
            }
        }
    }
    
    func deleteAll<T>(_ model: T.Type, predicate: NSPredicate? = nil) throws where T : Storable {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        fetch(model, predicate: predicate) { (objects) in
            try! self.safeWrite {
                for object in objects {
                    realm.delete(object as! Object)
                }
            }
        }
    }
    
    func reset() throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.deleteAll()
        }
    }
}

extension RealmStorageContext {
    func fetch<T>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: (([T]) -> Void)) where T : Storable {
        var objects = self.realm?.objects(model as! Object.Type)
        
        if let predicate = predicate {
            objects = objects?.filter(predicate)
        }
        
        if let sorted = sorted {
            objects = objects?.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        
        var accumulate: [T] = [T]()
        for object in objects! {
            accumulate.append(object as! T)
        }
        
        completion(accumulate)
    }
}

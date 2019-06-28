//
//  DBManager.swift
//  NPS Browser
//
//  Created by JK3Y on 8/10/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    
    let storage = try! RealmStorageContext()
    
    // MARK: Create
    func store(object: Storable) {
        do {
            try storage.safeWrite {
                storage.realm?.add(object as! Object)
            }
        } catch let error as NSError {
            log.error(error)
        }
    }
    
    func storeBulk(objArray: [Object]) {
        do {
            try storage.safeWrite {
                storage.realm?.add(objArray)
            }
        } catch let error as NSError {
            log.error(error)
        }
    }    
    
    // MARK: Read
    func fetch<T>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil) -> [T]{
        var objects = storage.realm?.objects(model as! Object.Type)
        
        if let predicate = predicate {
            objects = objects?.filter(predicate)
        }
        
        if let sorted = sorted {
            objects = objects?.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        
        var arr: [T] = [T]()
        for obj in objects! {
            arr.append(obj as! T)
        }
        
        return arr
    }
    
    // MARK: Delete
    func delete(object: Storable) {
        do {
            try storage.delete(object: object)
        } catch let error as NSError {
            log.error(error)
        }
    }
    
    func deleteAll<T: Storable>(_ model: T.Type) throws {
        do {
            try storage.safeWrite {
                let objects = storage.realm?.objects(model as! Object.Type)
                for object in objects! {
                    storage.realm?.delete(object)
                }
            }
        } catch let error as NSError {
            log.error(error)
        }
    }
}

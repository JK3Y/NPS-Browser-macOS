//
//  LayerAPI.swift
//  NPS Browser
//
//  Created by JK3Y on 8/11/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import RealmSwift

struct Sorted {
    var key: String
    var ascending: Bool = true
}

/*
 Operations on context
 */
protocol StorageContext {
    /*
     Create a new object with default values
     return an object that is conformed to the `Storable` protocol
     */
    func create<T: Storable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws
    
    /*
     Save an object that is conformed to the `Storable` protocol
     */
    func save(object: Storable) throws
    
    /*
     Update an object that is conformed to the `Storable` protocol
     */
    func update(block: @escaping () -> ()) throws
    
    /*
     Delete an object that is conformed to the `Storable` protocol
     */
    func delete(object: Storable) throws
    
    /*
     Deletes all objects that are conformed to the `Storable` protocol
     */
    func deleteAll<T: Storable>(_ model: T.Type) throws
    
    /*
     Deletes all objects that conform to the `Storable` protocol and match the given predicate
     */
    func deleteAll<T: Storable>(_ model: T.Type, predicate: NSPredicate?) throws
    
    /*
     Return a list of objects that conform to the `Storable` protocol
     */
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
}

//
//  NPSItemObject.swift
//  NPS Browser
//
//  Created by JK3Y on 8/4/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Layer Protocols
public protocol Storable {
}
extension Object: Storable {
}


// MARK: Layer API
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

// MARK: RealmStorageContext
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
            let newObject = realm.create(model as! Object.Type, value: [], update: false) as! T
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


//public class ModelObject: Object {
//    @objc public override func setValue(_ value: Any?, forKey key: String) {
//        self.realm?.beginWrite()
//
//        super.setValue(value, forKey: key)
//
//        try! self.realm?.commitWrite()
//    }
//}



//@objcMembers
//class CompatPack: Object {
//    enum Property: String {
//        case titleId, downloadUrl
//    }
//    
//    dynamic var titleId: String?
//    dynamic var downloadUrl: String?
//    
//    override static func primaryKey() -> String? {
//        return CompatPack.Property.titleId.rawValue
//    }
//}

@objcMembers
class Item: Object {
    enum Property: String {
        case titleId, region, name, pkgDirectLink, lastModificationDate, fileSize, sha256, contentId, consoleType, fileType, uuid
    }
    
    dynamic var uuid                    : String = UUID().uuidString
    dynamic var titleId                 : String?
    dynamic var region                  : String?
    dynamic var contentId               : String?
    dynamic var consoleType             : String?
    dynamic var fileType                : String?
    dynamic var name                    : String?
    dynamic var pkgDirectLink           : String?
    dynamic var rap                         : String?
    dynamic var downloadRapFile             : String?
    dynamic var zrif                       : String?
    let requiredFw = RealmOptional<Float>()
    dynamic var lastModificationDate    : Date?
    let fileSize = RealmOptional<Int64>()
    dynamic var sha256                  : String?

    override static func primaryKey() -> String? {
        return Item.Property.uuid.rawValue
    }
    
    convenience required init(tsvData: TSVData) {
        self.init()
        self.titleId = tsvData.titleId
        self.region = tsvData.region
        self.name = tsvData.name!
        self.pkgDirectLink = tsvData.pkgDirectLink
        self.lastModificationDate = tsvData.lastModificationDate
        self.fileSize.value = tsvData.fileSize
        self.sha256 = tsvData.sha256
        self.contentId = tsvData.contentId
        
        self.consoleType = tsvData.consoleType.rawValue
        self.fileType = tsvData.fileType.rawValue
        
        self.zrif = tsvData.zrif
        self.requiredFw.value = tsvData.requiredFw
        self.rap = tsvData.rap
        self.downloadRapFile = tsvData.downloadRapFile
    }
    
    static public func asObject(fromObject: Item) -> Item {
        let obj = Item()
        obj.titleId = fromObject.titleId
        obj.region = fromObject.region
        obj.name = fromObject.name
        obj.pkgDirectLink = fromObject.pkgDirectLink
        obj.lastModificationDate = fromObject.lastModificationDate
        obj.fileSize.value = fromObject.fileSize.value
        obj.sha256 = fromObject.sha256
        obj.contentId = fromObject.contentId
        obj.consoleType = fromObject.consoleType
        obj.fileType = fromObject.fileType
        
        obj.zrif = fromObject.zrif
        obj.requiredFw.value = fromObject.requiredFw.value
        obj.rap = fromObject.rap
        obj.downloadRapFile = fromObject.downloadRapFile
        return obj
    }
}





//@objcMembers
//class NPSItem: ModelObject {
//    enum Property: String {
//        case titleId, region, name, pkgDirectLink, lastModificationDate, fileSize, sha256, contentId, consoleType, fileType, uuid
//    }
//    
//    dynamic var titleId                 : String?
//    dynamic var region                  : String?
//    dynamic var name                    : String?
//    dynamic var pkgDirectLink           : String?
//    dynamic var lastModificationDate    : Date?
//    dynamic var fileSize                : Int64?
//    dynamic var sha256                  : String?
//    dynamic var contentId               : String?
//    
//    dynamic var consoleType             : String?
//    dynamic var fileType                : String?
//    dynamic var uuid                    : String = UUID().uuidString
//    
//
//    override static func primaryKey() -> String? {
//        return NPSItem.Property.uuid.rawValue
//    }
//    
//    func setProps(tsvData: TSVData) {
//        self.titleId = tsvData.titleId
//        self.region = tsvData.region
//        self.name = tsvData.name!
//        self.pkgDirectLink = tsvData.pkgDirectLink
//        self.lastModificationDate = tsvData.lastModificationDate
//        self.fileSize = tsvData.fileSize
//        self.sha256 = tsvData.sha256
//        self.contentId = tsvData.contentId
//        
//        consoleType = tsvData.consoleType.rawValue
//        fileType = tsvData.fileType.rawValue
//    }
//}
//
//extension NPSItem {
////    static func all(in realm: Realm = try! Realm()) -> Results<NPSItem> {
////        return realm.objects(NPSItem.self)
////        .sorted(byKeyPath: "titleId")
////    }
//}
//
//@objcMembers
//class PSV: NPSItem {
//    dynamic var zrif                       : String = ""
//    dynamic var originalName               : String = ""
//    let requiredFw = RealmOptional<Float>()
//
//    
//    public let referred = List<PSV>()
//    public let referrer = LinkingObjects(fromType: PSV.self, property: "referred")
//
//    
//    convenience required init(tsvData: TSVData) {
//        self.init()
//        self.setProps(tsvData: tsvData)
//        zrif = tsvData.zrif!
//        originalName = tsvData.originalName!
//        requiredFw.value = tsvData.requiredFw
//    }
//}
//
//@objcMembers
//class PS3: NPSItem {
//    dynamic var rap                         : String?
//    dynamic var downloadRapFile             : String?
//    
//    public let referred = List<PS3>()
//    public let referrer = LinkingObjects(fromType: PS3.self, property: "referred")
//
//    convenience required init(tsvData: TSVData) {
//        self.init()
//        self.setProps(tsvData: tsvData)
//        rap = tsvData.rap
//        downloadRapFile = tsvData.downloadRapFile
//    }
//}


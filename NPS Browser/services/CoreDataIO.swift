//
//  CoreDataIO.swift
//  NPS Browser
//
//  Created by JK3Y on 5/5/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import CoreData

class CoreDataIO: NSObject {
    
    let delegate = NSApplication.shared.delegate as! AppDelegate
    let windowDelegate: WindowDelegate = Helpers().getWindowDelegate()
//    let windowDelegate: WindowDelegate? = NSApplication.shared.mainWindow?.windowController as! WindowController
    
    var context: NSManagedObjectContext
    var type: String
    var region: String
    
    override init(){
        self.context    = delegate.persistentContainer.viewContext
        self.type       = windowDelegate.getType()
        self.region     = windowDelegate.getRegion()
        super.init()
    }
    
    func getContext() -> NSManagedObjectContext {
        return self.context
    }
    
    func getEntity(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.context)!
    }
    
    func getEntity() -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: self.type, in: self.context)!
    }
    
    func getObject(entity: NSEntityDescription) -> NSManagedObject {
        return NSManagedObject(
            entity: entity,
            insertInto: self.context
        )
    }
    
    func getObject() -> NSManagedObject {
        return NSManagedObject(
            entity: getEntity(),
            insertInto: self.context
        )
    }
    
    func storeValues(array: [NPSBase]) {
        
        array.forEach({ item in
            let nps = getObject()

            nps.setValue(item.title_id, forKey: "title_id")
            nps.setValue(item.region, forKey: "region")
            nps.setValue(item.name, forKey: "name")
            nps.setValue(item.pkg_direct_link, forKey: "pkg_direct_link")
            nps.setValue(item.last_modification_date, forKey: "last_modification_date")
            nps.setValue(item.file_size, forKey: "file_size")
            nps.setValue(item.sha256, forKey: "sha256")
            
            switch(self.type) {
            case "PSVGames":
                nps.setValue((item as! PSVGame).content_id, forKey: "content_id")
                nps.setValue((item as! PSVGame).original_name, forKey: "original_name")
                nps.setValue((item as! PSVGame).required_fw, forKey: "required_fw")
                nps.setValue((item as! PSVGame).zrif, forKey: "zrif")
                break
            case "PSVUpdates":
                nps.setValue((item as! PSVUpdate).update_version, forKey: "update_version")
                nps.setValue((item as! PSVUpdate).fw_version, forKey: "fw_version")
                nps.setValue((item as! PSVUpdate).nonpdrm_mirror, forKey: "nonpdrm_mirror")
                break
            case "PSVDLCs":
                nps.setValue((item as! PSVDLC).content_id, forKey: "content_id")
                nps.setValue((item as! PSVDLC).zrif, forKey: "zrif")
                break
            case "PSPGames":
                nps.setValue((item as! PSPGame).content_id, forKey: "content_id")
                nps.setValue((item as! PSPGame).rap, forKey: "rap")
                nps.setValue((item as! PSPGame).download_rap_file, forKey: "download_rap_file")
                break
            case "PSXGames":
                nps.setValue((item as! PSXGame).content_id, forKey: "content_id")
                nps.setValue((item as! PSXGame).original_name, forKey: "original_name")
                break
            default:
                break
            }
        })
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getRecords() -> [NSManagedObject]? {
        let req             = NSFetchRequest<NSManagedObject>(entityName: self.type)
        let predicate       = NSPredicate(format: "region == %@", self.region)
        req.predicate       = predicate
        req.sortDescriptors = [NSSortDescriptor(key: "title_id", ascending: true)]
        
        do {
            return try self.context.fetch(req)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func searchRecords(searchString: String) -> [NSManagedObject]? {
        let req             = NSFetchRequest<NSManagedObject>(entityName: self.type)
        let predicate       = NSPredicate(format: "region == %@ AND name contains[c] %@", self.region, searchString)
        req.predicate       = predicate
        req.sortDescriptors = [NSSortDescriptor(key: "title_id", ascending: true)]
        
        do {
            return try self.context.fetch(req)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func removeExpiredCache() {
        var plist: NSDictionary?
        if let path = Bundle.main.path(forResource: "ListTimestamps", ofType: "plist") {
            plist = NSDictionary(contentsOfFile: path)
        }
        if let p = plist {
            let lifespan    : Double = p.value(forKey: "refresh_after_hours") as! Double
            let timestamp   : Date = p.value(forKeyPath: self.type) as! Date
            let interval    : TimeInterval = 60 * 60 * lifespan
            let expires     = timestamp.addingTimeInterval(interval)
            
            if(expires < Date()) {
                batchDelete(type: self.type)
            }
        }
    }
    
    func batchDelete(type: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: type)
        let req = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try self.context.execute(req)
        } catch let error as NSError {
            print("Could not delete entity. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        let types = [
            "PSVGames",
            "PSVUpdates",
            "PSVDLCs",
            "PSPGames",
            "PSXGames",
            "Bookmarks"
        ]
        types.forEach { type in
            batchDelete(type: type)
        }
    }

    func updateCacheTimestamp() {
        var plist: NSDictionary?
        let path = Bundle.main.path(forResource: "ListTimestamps", ofType: "plist")
        if let dir = path {
            plist = NSDictionary(contentsOfFile: path!)
        }
        if let p = plist {
            p.setValue(Date(), forKey: self.type)
            p.write(toFile: path!, atomically: true)
        }
    }

    func recordsAreEmpty() -> Bool {
        let records = getRecords()
        if (records!.isEmpty) {
            return true
        }
        return false
    }
    
    // MARK: Bookmark Retrieval
    func getBookmarks() -> [NSManagedObject?] {
        let req = NSFetchRequest<NSManagedObject>(entityName: "Bookmarks")
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try self.context.fetch(req)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func parseCoreDataToBookmarks(data: [NSManagedObject?]) -> [Bookmark] {
        var bookmarks: [Bookmark] = []
        for item in data {
            
            debugPrint(item!.value(forKey: "item"))
            
            
            let name            = item!.value(forKey: "name") as! String
            let title_id        = item!.value(forKey: "title_id") as! String
            let type            = item!.value(forKey: "type") as! String
            let url             = item!.value(forKey: "url") as! URL
            let zrif            = item!.value(forKey: "zrif") as! String
//            let refObjectID     = item!.value(forKey: "refObjectID") as! NSManagedObjectID
            let bookmark    = Bookmark(name: name, title_id: title_id, type: type, zrif: zrif, url: url)
            bookmarks.append(bookmark)
        }
        return bookmarks
    }
}

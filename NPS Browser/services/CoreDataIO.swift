//
//  CoreDataIO.swift
//  NPS Browser
//
//  Created by JK3Y on 5/5/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Cocoa
import CoreData

class CoreDataIO: NSObject {
    
    let delegate = Helpers().getSharedAppDelegate()
    var context: NSManagedObjectContext
    let type: () -> String = {
        Helpers().getWindowDelegate().getType()
    }
    let region: () -> String = {
        Helpers().getWindowDelegate().getRegion()
    }
    
    override init(){
        context = delegate.persistentContainer.viewContext
        super.init()
    }
    
    func getContext() -> NSManagedObjectContext {
        return context
    }
    
    func getEntity(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }
    
    func getEntity() -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: type(), in: context)!
    }
    
    func getObject(entity: NSEntityDescription) -> NSManagedObject {
        return NSManagedObject(
            entity: entity,
            insertInto: context
        )
    }
    
    func getObject() -> NSManagedObject {
        return NSManagedObject(
            entity: getEntity(),
            insertInto: context
        )
    }
    
    func storeValues(array: [NPSBase]) {
        
        for item in array {
            let nps = getObject()
            
            nps.setValue(item.title_id, forKey: "title_id")
            nps.setValue(item.region, forKey: "region")
            nps.setValue(item.name, forKey: "name")
            nps.setValue(item.pkg_direct_link, forKey: "pkg_direct_link")
            nps.setValue(item.last_modification_date, forKey: "last_modification_date")
            nps.setValue(item.file_size, forKey: "file_size")
            nps.setValue(item.sha256, forKey: "sha256")
            nps.setValue(item.type, forKey: "type")
            nps.setValue(item.uuid, forKey: "uuid")
            
            let storedBookmark: BookmarksMO? = getRecordByUUID(entityName: "Bookmarks", uuid: item.uuid) as? BookmarksMO
            if (storedBookmark != nil) {
                nps.setValue(storedBookmark, forKey: "bookmark")
            }
            
            switch(item.type) {
            case "PSVGames":
                let obj = item as! PSVGame
                nps.setValue(obj.content_id, forKey: "content_id")
                nps.setValue(obj.original_name, forKey: "original_name")
                nps.setValue(obj.required_fw, forKey: "required_fw")
                nps.setValue(obj.zrif, forKey: "zrif")
            case "PSVUpdates":
                let obj = item as! PSVUpdate
                nps.setValue(obj.update_version, forKey: "update_version")
                nps.setValue(obj.fw_version, forKey: "fw_version")
                nps.setValue(obj.nonpdrm_mirror, forKey: "nonpdrm_mirror")
            case "PSVDLCs":
                let obj = item as! PSVDLC
                nps.setValue(obj.content_id, forKey: "content_id")
                nps.setValue(obj.zrif, forKey: "zrif")
            case "PSVThemes":
                let obj = item as! PSVTheme
                nps.setValue(obj.content_id, forKey: "content_id")
                nps.setValue(obj.zrif, forKey: "zrif")
            case "PSPGames":
                let obj = item as! PSPGame
                nps.setValue(obj.content_id, forKey: "content_id")
                nps.setValue(obj.rap, forKey: "rap")
                nps.setValue(obj.download_rap_file, forKey: "download_rap_file")
            case "PSXGames":
                let obj = item as! PSXGame
                nps.setValue(obj.content_id, forKey: "content_id")
                nps.setValue(obj.original_name, forKey: "original_name")
            default:
                break
            }
            
        }
        
        delegate.saveAction(self)
    }
    
    func getRecordByUUID(entityName: String, uuid: UUID) -> NSManagedObject? {
        let req             = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let predicate       = NSPredicate(format: "uuid == %@", uuid.uuidString)
        req.predicate       = predicate
        
        do {
            return try context.fetch(req).first
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func getRecords() -> [NSManagedObject]? {
        let req             = NSFetchRequest<NSManagedObject>(entityName: type())

        if (SettingsManager().getDisplay().hide_invalid_url_items) {
            req.predicate = NSPredicate(format: "region == %@ AND pkg_direct_link != 'MISSING'", region())
        } else {
            req.predicate = NSPredicate(format: "region == %@", region())
        }

        req.sortDescriptors = [NSSortDescriptor(key: "title_id", ascending: true)]
        
        do {
            return try context.fetch(req)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func searchRecords(searchString: String) -> [NSManagedObject]? {
        let req             = NSFetchRequest<NSManagedObject>(entityName: type())
        
        if (SettingsManager().getDisplay().hide_invalid_url_items) {
            req.predicate = NSPredicate(format: "region == %@ AND name contains[c] %@ AND pkg_direct_link != 'MISSING'", region(), searchString)
        } else {
            req.predicate = NSPredicate(format: "region == %@ AND name contains[c] %@", region(), searchString)
        }
        
        req.sortDescriptors = [NSSortDescriptor(key: "title_id", ascending: true)]
        
        do {
            return try context.fetch(req)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func batchDelete(typeName: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: typeName)
        let predicate = NSPredicate(format: "type == %@", typeName)
        fetch.predicate = predicate
        let req = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(req) as? NSBatchDeleteResult
        } catch let error as NSError {
            print("Could not delete entity. \(error), \(error.userInfo)")
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
            return try context.fetch(req)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}

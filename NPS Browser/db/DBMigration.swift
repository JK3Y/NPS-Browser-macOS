//
//  DBMigration.swift
//  NPS Browser
//
//  Created by JK3Y on 8/25/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import RealmSwift

final class DBMigration {
    // MARK: - Properties
    static let currentSchemaVersion: UInt64 = 0
    
    static func configureMigration() -> Realm {
        let config = Realm.Configuration(
            // Set the new schema version here. This must be greater than the previous version
            schemaVersion: 1,
            
            migrationBlock: { migration, oldSchemaVersion in
                switch oldSchemaVersion {
                case 1:
                    break
                default:
                    // Nothing to do!
                    // Realm will automatically detect new/removed properties and update schema on disk
                    zeroToOne(with: migration)
                }
            }
        )
        
        // Tell Realm to use this new configuration object for the default Realm
        return try! Realm(configuration: config)
    }
    
    
    // MARK: - Migrations
    static func zeroToOne(with migration: Migration) {
        

        migration.enumerateObjects(ofType: Item.className()) { oldItem, newItem in
//            oldItem.to
            
            newItem!["requiredFw"] = Double(oldItem!["requiredFw"] as! Float)
            
            let filetype = oldItem!["fileType"] as! String
            let tid = oldItem!["titleId"] as! String
            let reg = oldItem!["region"] as! String
            let cid = oldItem!["contentId"] as! String
            
            newItem?["pk"] = "\(reg)\(filetype)\(tid)\(cid)"
        }
//        migration.enumerateObjects(ofType: Item.className()) { oldItem, newItem in
//            guard let fn = oldItem?["pkgDirectLink"] as? String else {
//                fatalError("Invalid pkgDirectLink: \(oldItem!["pkgDirectLink"] as! String)")
//            }
//            if let fnurl = URL(string: fn) {
//                let filename = fnurl.deletingPathExtension().lastPathComponent.appending(oldItem!["contentId"] as! String)
//                let filetype = oldItem!["fileType"] as! String
//                let tid = oldItem!["titleId"] as! String
//                let reg = oldItem!["region"] as! String
//                newItem?["uuid"] = "\(tid)\(reg)\(filetype)\(filename)"
//            } else {
//                newItem?["uuid"] = UUID().uuidString
//                log.error("Invalid UUID supplied for newItem")
//            }
//        }
    }
}

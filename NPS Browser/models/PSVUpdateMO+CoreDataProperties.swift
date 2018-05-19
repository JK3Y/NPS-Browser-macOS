//
//  PSVUpdateMO+CoreDataProperties.swift
//  
//
//  Created by Jacob Amador on 5/12/18.
//
//

import Foundation
import CoreData


extension PSVUpdateMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PSVUpdateMO> {
        return NSFetchRequest<PSVUpdateMO>(entityName: "PSVUpdates")
    }

    @NSManaged public var fw_version: String?
    @NSManaged public var nonpdrm_mirror: String?
    @NSManaged public var update_version: String?

}

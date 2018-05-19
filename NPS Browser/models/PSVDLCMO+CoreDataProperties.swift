//
//  PSVDLCMO+CoreDataProperties.swift
//  
//
//  Created by Jacob Amador on 5/12/18.
//
//

import Foundation
import CoreData


extension PSVDLCMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PSVDLCMO> {
        return NSFetchRequest<PSVDLCMO>(entityName: "PSVDLCs")
    }

    @NSManaged public var zrif: String?

}

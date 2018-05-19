//
//  PSVGameMO+CoreDataProperties.swift
//  
//
//  Created by Jacob Amador on 5/12/18.
//
//

import Foundation
import CoreData


extension PSVGameMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PSVGameMO> {
        return NSFetchRequest<PSVGameMO>(entityName: "PSVGames")
    }

    @NSManaged public var original_name: String?
    @NSManaged public var required_fw: String?
    @NSManaged public var zrif: String?

}

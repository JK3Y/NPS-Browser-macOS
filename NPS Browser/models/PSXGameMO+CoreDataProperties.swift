//
//  PSXGameMO+CoreDataProperties.swift
//  
//
//  Created by Jacob Amador on 5/12/18.
//
//

import Foundation
import CoreData


extension PSXGameMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PSXGameMO> {
        return NSFetchRequest<PSXGameMO>(entityName: "PSXGames")
    }

    @NSManaged public var content_id: String?
    @NSManaged public var file_size: String?
    @NSManaged public var last_modification_date: String?
    @NSManaged public var name: String?
    @NSManaged public var pkg_direct_link: URL?
    @NSManaged public var region: String?
    @NSManaged public var sha256: String?
    @NSManaged public var title_id: String?

}

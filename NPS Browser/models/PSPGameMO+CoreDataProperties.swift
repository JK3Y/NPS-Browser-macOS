//
//  PSPGameMO+CoreDataProperties.swift
//  
//
//  Created by Jacob Amador on 5/12/18.
//
//

import Foundation
import CoreData


extension PSPGameMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PSPGameMO> {
        return NSFetchRequest<PSPGameMO>(entityName: "PSPGames")
    }

    @NSManaged public var rap_download: String?
    @NSManaged public var rap_file: String?
    @NSManaged public var type: String?

}

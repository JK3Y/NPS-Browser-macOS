//
//  Bookmark.swift
//  NPS Browser
//
//  Created by JK3Y on 8/11/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Bookmark: Object {
    enum Property: String {
        case titleId,downloadUrl, name, type, zrif, uuid
    }
    
    dynamic var titleId: String?
    dynamic var downloadUrl: String?
    dynamic var name: String?
    dynamic var fileType: String?
    dynamic var consoleType: String?
    dynamic var zrif: String?
    dynamic var uuid: String?
    
    override static func primaryKey() -> String? {
        return Bookmark.Property.uuid.rawValue
    }
    
    convenience init(item: Item) {
        self.init()
        self.titleId = item.titleId
        self.downloadUrl = item.pkgDirectLink
        self.name = item.name
        self.fileType = item.fileType
        self.consoleType = item.consoleType
        self.zrif = item.zrif
        self.uuid = item.pk
    }
}

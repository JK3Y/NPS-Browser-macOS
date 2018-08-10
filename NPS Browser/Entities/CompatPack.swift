//
//  CompatPack.swift
//  NPS Browser
//
//  Created by JK3Y on 8/10/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import RealmSwift

@objcMembers
class CompatPack: Object {
    enum Property: String {
        case titleId, downloadUrl, type, uuid
    }
    
    dynamic var titleId: String?
    dynamic var downloadUrl: String?
    dynamic var type: String?
    dynamic var uuid: String = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return CompatPack.Property.uuid.rawValue
    }
}

@objcMembers
class Bookmark: Object {
    enum Property: String {
        case titleId,downloadUrl, name, type, zrif, uuid
    }
    
    dynamic var titleId: String?
    dynamic var downloadUrl: String?
    dynamic var name: String?
    dynamic var type: String?
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
        self.type = item.fileType
        self.zrif = item.zrif
        self.uuid = item.uuid
    }
}

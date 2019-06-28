//
//  CompatPack.swift
//  NPS Browser
//
//  Created by JK3Y on 8/10/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
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

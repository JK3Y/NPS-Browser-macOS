//
//  NPSModels.swift
//  Swift NPS Browser
//
//  Created by JK3Y on 5/14/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation

class NPSBase {
    var title_id                    : String?
    var region                      : String?
    var name                        : String?
    var pkg_direct_link             : URL?
    var last_modification_date      : Date?
    var file_size                   : Int64?
    var sha256                      : String?
    init(_ valueDict: [String: String]) {
        self.title_id                    = valueDict["title_id"]
        self.region                      = valueDict["region"]
        self.name                        = valueDict["name"]
        self.pkg_direct_link             = URL(string: valueDict["pkg_direct_link"]!)
        self.last_modification_date      = parseDate(dateString: valueDict["last_modification_date"]!)
        self.file_size                   = Int64(valueDict["file_size"]!)
        self.sha256                      = valueDict["sha256"]
    }
    
    func parseDate(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else {
            debugPrint("Failed to parse date: \(dateString)")
            return nil
        }
        return date
    }
}

class PSVGame: NPSBase {
    var zrif            : String?
    var content_id      : String?
    var original_name   : String?
    var required_fw     : Float?
    override init(_ valueDict: [String : String]) {
        self.zrif           = valueDict["zrif"]
        self.content_id     = valueDict["content_id"]
        self.original_name  = valueDict["original_name"]
        self.required_fw    = Float(valueDict["required_fw"]!)
        super.init(valueDict)
    }
}

class PSVUpdate: NPSBase {
    var update_version  : Float?
    var fw_version      : Float?
    var nonpdrm_mirror  : URL?
    override init(_ valueDict: [String : String]) {
        self.update_version = Float(valueDict["update_version"]!)
        self.fw_version     = Float(valueDict["fw_version"]!)
        self.nonpdrm_mirror = URL(string: valueDict["nonpdrm_mirror"]!)
        super.init(valueDict)
    }
}

class PSVDLC: NPSBase {
    var zrif        : String?
    var content_id  : String?
    override init(_ valueDict: [String: String]) {
        self.zrif       = valueDict["zrif"]
        self.content_id = valueDict["content_id"]
        super.init(valueDict)
    }
}

class PSXGame: NPSBase {
    var content_id      : String?
    var original_name   : String?
    override init(_ valueDict: [String : String]) {
        self.content_id     = valueDict["content_id"]
        self.original_name  = valueDict["original_name"]
        super.init(valueDict)
    }
}

class PSPGame: NPSBase {
    var type                : String?
    var content_id          : String?
    var rap                 : String?
    var download_rap_file   : String?
    override init(_ valueDict: [String: String]) {
        self.type               = valueDict["type"]
        self.content_id         = valueDict["content_id"]
        self.rap                = valueDict["rap"]
        self.download_rap_file  = valueDict["content_id"]
        super.init(valueDict)
    }
}

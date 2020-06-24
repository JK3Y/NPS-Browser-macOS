//
//  TSVData.swift
//  NPS Browser
//
//  Created by JK3Y on 8/4/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation

struct TSVData {
    var titleId                 : String?
    var region                  : String?
    var name                    : String?
    var pkgDirectLink           : String?
    var lastModificationDate    : Date?
    var fileSize                : Int64?
    var sha256                  : String?
    var zrif                    : String?
    var contentId               : String?
    var originalName            : String?
    var requiredFw              : Float?
    var rap                     : String?
    var downloadRapFile         : String?
    var consoleType             : ConsoleType
    var fileType                : FileType
    
    init(type: ItemType, values: [String]) {
        consoleType = type.console
        fileType = type.fileType
        titleId = values[0]
        region = values[1]

        switch type.console {
        case .PSV:
            switch type.fileType {
            case .Game:
                name                  = values[2]
                pkgDirectLink         = values[3]
                zrif                  = values[4]
                contentId             = values[5]
                lastModificationDate  = parseDate(dateString: values[6])
                originalName          = values[7]
                fileSize              = Int64(values[8])
                sha256                = values[9]
                requiredFw            = Float(values[10])
            case .DLC, .Theme:
                name                  = values[2]
                pkgDirectLink         = values[3]
                zrif                  = values[4]
                contentId             = values[5]
                lastModificationDate  = parseDate(dateString: values[6])
                fileSize              = Int64(values[7])
                sha256                = values[8]
            default: break
            }
        case .PS3:
            let baseURL = "https://nopaystation.com/tools/rap2file"
            name                      = values[2]
            pkgDirectLink             = values[3]
            rap                       = values[4]
            contentId                 = values[5]
            lastModificationDate      = parseDate(dateString: values[6])
            downloadRapFile           = "\(baseURL)/\(values[5])/\(values[4])"
            fileSize                  = Int64(values[8])
            sha256                    = values[9]
        case .PSP:
            name                      = values[3]
            pkgDirectLink             = values[4]
            contentId                 = values[5]
            lastModificationDate      = parseDate(dateString: values[6])
            rap                       = values[7]
            downloadRapFile           = values[8]
            fileSize                  = Int64(values[9])
            sha256                    = values[10]
        case .PSX:
            name                      = values[2]
            pkgDirectLink             = values[3]
            contentId                 = values[4]
            lastModificationDate      = parseDate(dateString: values[5])
            originalName              = values[6]
            fileSize                  = Int64(values[7])
            sha256                    = values[8]
        }
    }
 
    func parseDate(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        return date
    }
}

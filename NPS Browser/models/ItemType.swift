//
//  FileInfo.swift
//  NPS Browser
//
//  Created by JK3Y on 8/2/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation

enum ConsoleType: String {
    case PSV, PS3, PSX, PSP
}

enum FileType: String {
    case Game, Update, DLC, Theme, Avatar, CPack, CPatch, RAP
}

struct ItemType: CustomStringConvertible {
    var console: ConsoleType
    var fileType: FileType
    var description: String {
        return "ConsoleType: \(console.rawValue), FileType: \(fileType.rawValue)"
    }
    init(console: ConsoleType, fileType: FileType) {
        self.console = console
        self.fileType = fileType
    }
    static func parseString(_ txt: String) -> ItemType {
        let parsed = try txt.split(separator: " ")
        let c = ConsoleType(rawValue: String(parsed.first!))
        let ft = FileType(rawValue: String(parsed.last!.dropLast()))
        return ItemType(console: c!, fileType: ft!)
    }
}

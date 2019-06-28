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
    static func getTypeFromTag(_ tag: Int) -> FileType {
        switch (tag) {
        case 0:
            return FileType.Game
        case 1:
            return FileType.DLC
        case 2:
            return FileType.Theme
        case 3:
            return FileType.Update
        case 4:
            return FileType.Avatar
        case 5:
            return FileType.CPack
        case 6:
            return FileType.CPatch
        case 7:
            return FileType.RAP
        default:
            return FileType.Game
        }
    }
    static func parseString(_ txt: String = "", _ type: FileType) -> ItemType {
        let parsed = try txt.split(separator: " ")
        let c = ConsoleType(rawValue: String(parsed.first ?? ""))
//        let ft = FileType(rawValue: String(parsed.last?.dropLast() ?? ""))
        let ft = type
        return ItemType(console: c ?? ConsoleType.PSV, fileType: ft)
    }
}

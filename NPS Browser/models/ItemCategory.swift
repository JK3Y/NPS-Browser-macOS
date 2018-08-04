//
//  ItemType.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation

enum SoftwareType {
    case Game, DLC, Update, Theme, Avatar
}

struct FileType {
    var type: SoftwareType?
    var console: ConsoleType?
    init(ddlSelectedType: String) {
        let c = String(ddlSelectedType.prefix(3))
        let t = String(ddlSelectedType.suffix(ddlSelectedType.count).dropLast())
        type = try! getType(txt: t)!
        console = try! getConsole(txt: c)!
    }
    
    func getConsole(txt: String) -> ConsoleType? {
        var type: ConsoleType?
        switch(txt) {
        case "PSV": return .Vita
        case "PS3": return .PS3
        case "PSP": return .PSP
        case "PSX": return .PSX
        default: break
        }
        return type
    }
    
    func getType(txt: String) -> SoftwareType? {
        var type: SoftwareType?
        switch(txt) {
        case "Game": return .Game
        case "DLC": return .DLC
        case "Update": return .Update
        case "Theme": return .Theme
        case "Avatar": return .Avatar
        default: break
        }
        return type
    }
}

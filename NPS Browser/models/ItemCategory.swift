//
//  ItemType.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation

enum ItemType: String {
    case Game, DLC, Update, Theme, Avatar
}

//struct ItemCategory {
//    var type: ItemType
//    var console: ConsoleType
//    init(ddlSelectedType: String) {
//        let c = ddlSelectedType.prefix(3)
//        let t = ddlSelectedType.suffix(ddlSelectedType.count).dropLast()
//        
//    }
//    
//    func getConsole(txt: String) -> ConsoleType {
//        switch(txt) {
//        case "PSV": return .Vita
//        case "PS3": return .PS3
//        case "PSP": return .PSP
//        case "PSX": return .PSX
//        default: break
//        }
//    }
//    
//    func getType(txt: String) -> ItemType {
//        switch(txt) {
//        case "Game": return .Game
//        case "DLC": return .DLC
//        case "Update": return .Update
//        case "Theme": return .Theme
//        case "Avatar": return .Avatar
//        default: break
//        }
//    }
//}

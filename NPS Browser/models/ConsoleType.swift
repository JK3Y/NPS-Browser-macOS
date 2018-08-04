//
//  ConsoleType.swift
//  NPS Browser
//
//  Created by JK3Y on 8/2/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation

enum ConsoleType: String {
    case Vita, PS3, PSX, PSP
}

struct Console {
    var type: ConsoleType?
    init(prefix: String) {
        switch(prefix) {
        case "PSV": type = .Vita
        case "PS3": type = .PS3
        case "PSP": type = .PS3
        case "PSX": type = .PSX
        default: break
        }
    }
    
    func toString() -> String {
        return (type?.rawValue)!
    }
}

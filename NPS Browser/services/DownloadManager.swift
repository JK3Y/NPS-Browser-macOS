//
//  DownloadManager.swift
//  NPS Browser
//
//  Created by Jacob Amador on 5/18/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

struct Item {
    var name: String
    var url: String?
    var progress: Double = 0
}

class DownloadManager {
    
    var queue: [Item] = []
    
    

}

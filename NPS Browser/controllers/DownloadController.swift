//
//  DownloadController.swift
//  NPS Browser
//
//  Created by Jacob Amador on 5/18/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DownloadController: NSViewController, DownloadControllerDelegate {
    @IBOutlet weak var dlTableView: NSTableView!
    @IBOutlet var dlArrayController: NSArrayController!

    var queue = Array<[String: Any]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//
//        var item = [
//            "name": "Test Item",
//            "url": "http://fakeurl.url",
//            "progress": 0.0,
//            ] as [String : Any]
//
//        queue.append(item)
//        dlArrayController.content = queue
//        
//        debugPrint(dlArrayController.content)
    }
    
    
    func addToQueue(data: [String : Any]) {
        queue.append(data)
        dlArrayController.content = queue
    }
}

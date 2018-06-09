//
//  DownloadController.swift
//  NPS Browser
//
//  Created by JK3Y on 5/18/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DownloadController: NSViewController {

    @IBOutlet weak var dlTableView: NSTableView!
    @IBOutlet var dlArrayController: NSArrayController!
    let windowDelegate: WindowDelegate? = NSApplication.shared.mainWindow?.windowController as! WindowController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        updateDownloadView()
    }
    
    @IBAction func clearCompleted(_ sender: Any) {
        windowDelegate?.removeCompletedFromDownloadQueue()
        updateDownloadView()
    }
    
    func updateDownloadView() {
        let content = windowDelegate?.getDownloadQueue()
        dlArrayController.content = content
    }
}

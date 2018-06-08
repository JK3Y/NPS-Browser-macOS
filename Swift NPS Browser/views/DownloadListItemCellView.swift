//
//  DownloadListItemCellView.swift
//  Swift NPS Browser
//
//  Created by JK3Y on 5/19/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DownloadListItemCellView: NSTableCellView {
    
    @IBOutlet weak var btnView: NSButton!
    @IBOutlet weak var btnCancel: NSButton!
    let windowDelegate: WindowDelegate? = NSApp.mainWindow?.windowController as! WindowController
    var item: DLItem?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        item = objectValue as? DLItem
    }
    
    @IBAction func doCancelRequest(_ sender: NSButton) {
        if (item!.isCancelable) {
            item!.request?.cancel()
            
            item!.status = "Cancelled"
            item!.isCancelable = false
        }
        
        else if (item!.isRemovable) {
            windowDelegate?.removeCompletedFromDownloadQueue()
        }
    }
    
    @IBAction func doViewDownloadedFile(_ sender: NSButton) {
        let dlLoc = SettingsManager().getDownloads()["download_location"]!.appendingPathComponent("app/\(item!.title_id!)")
        NSWorkspace.shared.open(dlLoc)
    }
}

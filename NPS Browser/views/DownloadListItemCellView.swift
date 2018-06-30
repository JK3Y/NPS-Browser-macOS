//
//  DownloadListItemCellView.swift
//  NPS Browser
//
//  Created by JK3Y on 5/19/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DownloadListItemCellView: NSTableCellView {
    
    @IBOutlet weak var btnView: NSButton!
    @IBOutlet weak var btnCancel: NSButton!
    @IBOutlet weak var btnRetry: NSButton!
    var item: DLItem?
    var dlLoc = SettingsManager().getDownloads().download_location

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
        item = objectValue as? DLItem
    }
    
    @IBAction func doCancelRequest(_ sender: NSButton) {
        if (item!.isCancelable) {
            item!.request?.cancel()
            item!.status = "Cancelled"
            item!.makeResumable()
        }
    }
    
    @IBAction func doViewDownloadedFile(_ sender: NSButton) {
        let extractSettings = SettingsManager().getExtract()
        
        if (item!.type == "PS3Games") {
            NSWorkspace.shared.open(dlLoc)
        }
        
        if (extractSettings.extract_after_downloading) {
            dlLoc.appendPathComponent("app/\(item!.title_id!)")
        }
        
        NSWorkspace.shared.open(dlLoc)
    }
    @IBAction func doRetryRequest(_ sender: NSButton) {
        item!.status = "Retrying..."
        Helpers().getSharedAppDelegate().downloadManager.resumeDownload(data: item!)
    }
}

//
//  DownloadListItemCellView.swift
//  NPS Browser
//
//  Created by JK3Y on 5/19/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import SwiftyUserDefaults

class DownloadListItemCellView: NSTableCellView {
    
    @IBOutlet weak var btnView: NSButton!
    @IBOutlet weak var btnCancel: NSButton!
    @IBOutlet weak var btnRetry: NSButton!
    var item: DLItem?
    var dlLoc = Defaults[.dl_library_folder]

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
        if Defaults[.xt_extract_after_downloading] {
            let ct:ConsoleType = ConsoleType(rawValue: item!.consoleType!)!
            let ft:FileType = FileType(rawValue: item!.fileType!)!
            
            dlLoc?.appendPathComponent(item!.consoleType!)
            
            switch (ct) {
            case .PSV:
                switch(ft) {
                case .Game:
                    dlLoc?.appendPathComponent("app/\(item!.titleId!)")
                case .DLC:
                    dlLoc?.appendPathComponent("addcont/\(item!.titleId!)")
                case .Update:
                    dlLoc?.appendPathComponent("patch/\(item!.titleId!)")
                case .Theme:
                    dlLoc?.appendPathComponent("bgdl/t")
                default: break
                }
            case .PS3:
                NSWorkspace.shared.open(dlLoc!)
            case .PSP:
                dlLoc?.appendPathComponent("pspemu/ISO")
            case .PSX:
                dlLoc?.appendPathComponent("pspemu/")
            }
        }
        
        let str = dlLoc?.absoluteString.removingPercentEncoding
        let path = URL(fileURLWithPath: str!, isDirectory: true)
        
        NSWorkspace.shared.open(path)
    }
    @IBAction func doRetryRequest(_ sender: NSButton) {
        item!.status = "Retrying..."
        Helpers().getSharedAppDelegate().downloadManager.resumeDownload(data: item!)
    }
}

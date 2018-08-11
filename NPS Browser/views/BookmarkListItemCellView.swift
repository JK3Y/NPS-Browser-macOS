//
//  BookmarkListItemCellView.swift
//  NPS Browser
//
//  Created by JK3Y on 6/9/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class BookmarkListItemCellView: NSTableCellView {
    var item: Bookmark?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.item = objectValue as? Bookmark
    }
    
    @IBAction func btnDownloadClicked(_ sender: NSButton) {
        
        // TODO: Add all 3 download types to DL list
        
        let dlItem              = DLItem()
        dlItem.fileType         = self.item?.fileType
        dlItem.consoleType      = self.item?.consoleType
        dlItem.titleId         = self.item?.titleId
        dlItem.name             = self.item?.name
        dlItem.downloadUrl    = URL(string: (self.item?.downloadUrl)!)
        dlItem.zrif             = self.item?.zrif
        
        
        Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: dlItem)
    }
}

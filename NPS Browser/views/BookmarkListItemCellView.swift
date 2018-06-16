//
//  BookmarkListItemCellView.swift
//  NPS Browser
//
//  Created by JK3Y on 6/9/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class BookmarkListItemCellView: NSTableCellView {
    var item: BookmarksMO?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.item = objectValue as! BookmarksMO
    }
    
    @IBAction func btnDownloadClicked(_ sender: NSButton) {
        let dlItem              = DLItem()
        dlItem.type             = self.item?.type
        dlItem.title_id         = self.item?.title_id
        dlItem.name             = self.item?.name
        dlItem.pkg_direct_link  = self.item?.pkg_direct_link
        dlItem.zrif             = self.item?.zrif
        Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: dlItem)
    }
}

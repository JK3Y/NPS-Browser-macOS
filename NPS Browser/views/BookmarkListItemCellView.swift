//
//  BookmarkListItemCellView.swift
//  NPS Browser
//
//  Created by JK3Y on 6/9/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class BookmarkListItemCellView: NSTableCellView {
    var bookmark: Bookmark?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.bookmark = objectValue as? Bookmark
    }
    
//    @IBAction func btnDownloadClicked(_ sender: NSButton) {
//        print("bookmark download clicked")
//    }
    
//    @IBAction func btnRemoveClicked(_ sender: NSButton) {
//        Helpers().getWindowController().bookmarkManager.removeBookmark(bookmark: bookmark!)
//        
//        self.superview
//    }
}

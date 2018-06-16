//
//  BookmarkToggleCelView.swift
//  NPS Browser
//
//  Created by JK3Y on 6/15/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class BookmarkToggleCellView: NSTableCellView {
    
    @IBOutlet weak var btnBookmark: NSButton!
    var item: AnyObject?
    
//        {
//        didSet {
//            debugPrint("DID SET ITEM")
//            debugPrint(self.item!.value(forKey: "title_id")!)
//        }
//    }

    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
//        btnBookmark.state = .off
        
//        self.item = objectValue as! AnyObject
        
//        btnBookmark.identifier = NSUserInterfaceItemIdentifier(rawValue: self.item!.value(forKey: "title_id") as! String)
//
//        debugPrint(self.item)

//        if ( self.item!.value(forKey: "bookmark") == nil) {
//            btnBookmark.state = .off
//        } else {
//            btnBookmark.state = .on
//
//            Helpers().getSharedAppDelegate().bookmarkManager.addBookmarkButtonIDToArray(
//                title_id: (objectValue as! AnyObject).value(forKey: "title_id") as! String,
//                button: btnBookmark
//            )
//        }
    }
    
//    override var objectValue: Any? {
//        didSet {
//
//            debugPrint(objectValue)
//
//            if ( (objectValue as! AnyObject).value(forKey: "bookmark") == nil) {
//                btnBookmark.state = .off
//            } else {
//                btnBookmark.state = .on
//                Helpers().getSharedAppDelegate().bookmarkManager.addBookmarkButtonIDToArray(
//                    title_id: (objectValue as! AnyObject).value(forKey: "title_id") as! String,
//                    button: btnBookmark
//                )
//            }
//        }
//    }
    
    @IBAction func toggleBookmark(_ sender: NSButton) {
        self.item = objectValue as! NSManagedObject
        print(self.item!)
        
        let bookmark: Bookmark = Helpers().makeBookmark(rowData: self.item!)
        
        if (sender.state == .on) {
            Helpers().getSharedAppDelegate().bookmarkManager.addBookmark(bookmark: bookmark, item: self.item as! NSManagedObject, sender: sender)
        } else {
            Helpers().getSharedAppDelegate().bookmarkManager.removeBookmark(bookmark)
        }
    }
    
}

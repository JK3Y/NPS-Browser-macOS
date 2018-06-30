//
//  BookmarksViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 6/9/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class BookmarksViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet var bookmarksArrayController: NSArrayController!
    
    let bookmarkManager: BookmarkManager = Helpers().getSharedAppDelegate().bookmarkManager
    
    override func viewDidLoad() {
        updateView()
        super.viewDidLoad()
    }
    
    @IBAction func doRemoveBookmark(_ sender: NSButton) {
        let rowData = Helpers().getRowObjectFromTableRowButton(sender) as AnyObject
        
        let bookmark = Helpers().makeBookmark(data: rowData)
        
        bookmarkManager.removeBookmark(bookmark)
        
        Helpers().getDataController().getDetailsViewController().toggleBookmark(compareUUID: bookmark.uuid)
        
        updateView()
    }
    
    func updateView() {
        let content = self.bookmarkManager.getBookmarkList()
        bookmarksArrayController.content = content
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        updateView()
    }
    
    @IBAction func doRemoveBookmark(_ sender: NSButton) {
        let bookmark = Helpers().getRowObjectFromTableRowButton(sender) as! Bookmark
        updateView()
        Helpers().getSharedAppDelegate().bookmarkManager.removeBookmark(bookmark)
    }
    
    func updateView() {
        let content = Helpers().getSharedAppDelegate().bookmarkManager.getBookmarkList()
        bookmarksArrayController.content = content
    }
}

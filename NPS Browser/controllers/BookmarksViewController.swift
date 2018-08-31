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
        updateView()
        super.viewDidLoad()
    }
    
    @IBAction func doRemoveBookmark(_ sender: NSButton) {
        let bookmark = Helpers().getRowObjectFromTableRowButton(sender) as! Bookmark
        let uuid = bookmark.uuid

        let storedBookmark = DBManager().fetch(Bookmark.self, predicate: NSPredicate(format: "uuid == %@", uuid!)).first
        
        DBManager().delete(object: storedBookmark!)

        Helpers().getDataController().getDetailsViewController().toggleBookmark(comparePK: uuid!)

        updateView()
    }
    
    func updateView() {
        let content = DBManager().fetch(Bookmark.self)
        bookmarksArrayController.content = content
    }
}

//
//  DetailsController.swift
//  NPS Browser
//
//  Created by JK3Y on 5/6/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DetailsViewController: NSViewController {
    
    @IBOutlet weak var chkBookmark: NSButton!
    @IBOutlet weak var btnDownload: NSButton!

    var windowDelegate: WindowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override var representedObject: Any? {
        didSet {
            self.toggleDownloadButton()
            self.toggleBookmark()
        }
    }

    @IBAction func btnDownloadClicked(_ sender: Any) {
        self.sendDLData()
    }
    
    @IBAction func btnBookmarkToggle(_ sender: NSButton) {
        let bookmark: Bookmark = Helpers().makeBookmark(data: representedObject as AnyObject)

        if (sender.state == .on) {
            Helpers().getSharedAppDelegate().bookmarkManager.addBookmark(bookmark: bookmark, item: representedObject as! NSManagedObject)
        } else {
            Helpers().getSharedAppDelegate().bookmarkManager.removeBookmark(bookmark)
        }
    }
    
    func toggleBookmark() {
        if ((representedObject as! NSManagedObject).value(forKey: "bookmark") != nil) {
            chkBookmark.state = .on
        } else {
            chkBookmark.state = .off
        }
    }
    
    func toggleBookmark(compareChecksum: String) {
        let objChecksum: String = (representedObject as! NSManagedObject).value(forKey: "sha256") as! String
        if (objChecksum == compareChecksum) {
            chkBookmark.state = .off
        }
    }
    
    func toggleDownloadButton() {
        let link = ((representedObject as! NSManagedObject).value(forKey: "pkg_direct_link") as! URL?)?.absoluteString
        if (link == "MISSING") {
            self.btnDownload.isEnabled = false
        } else {
            self.btnDownload.isEnabled = true
        }
    }
    
    func sendDLData() {
        let dlitem = Helpers().makeDLItem(data: representedObject as! NSManagedObject)
        Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: dlitem)
    }
}

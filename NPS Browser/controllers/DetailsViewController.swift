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
    @IBOutlet weak var btnRAPDownload: NSButton!
    
    var windowDelegate: WindowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override var representedObject: Any? {
        didSet {
            enableDownloadAndBookmarkButtons()
            toggleBookmark()
            
            let uid = (representedObject as! NSManagedObject).value(forKey: "uuid") as! UUID
            debugPrint(uid, uid.uuidString)
        }
    }

    @IBAction func btnDownloadClicked(_ sender: Any) {
        sendDLData()
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
        let bookmark = Helpers().getCoreDataIO().getRecordByUUID(entityName: "Bookmarks", uuid: (representedObject as! NSManagedObject).value(forKey: "uuid") as! UUID)

        if ( bookmark != nil) {
            chkBookmark.state = .on
        } else {
            chkBookmark.state = .off
        }
    }
    
    func toggleBookmark(compareUUID: UUID) {
        let obj: NSUUID = (representedObject as! NSManagedObject).value(forKey: "uuid") as! NSUUID
        if (obj.isEqual(to: (compareUUID as NSUUID))) {
            chkBookmark.state = .off
        }
    }
    
    func enableDownloadAndBookmarkButtons() {
        let link = ((representedObject as! NSManagedObject).value(forKey: "pkg_direct_link") as! URL?)?.absoluteString
//        let type = ((representedObject as! NSManagedObject).value(forKey: "type") as! String)

        if (link == "MISSING") {
            btnDownload.isEnabled = false
            chkBookmark.isEnabled = false
        } else {
            btnDownload.isEnabled = true
            chkBookmark.isEnabled = true
        }
        
//        if (type == "PS3Games") {
//            let rap = ((representedObject as! NSManagedObject).value(forKey: "download_rap_file") as! URL?)?.absoluteString
//        }
    }

    func sendDLData() {
        let dlitem = Helpers().makeDLItem(data: representedObject as! NSManagedObject)
        Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: dlitem)
    }
}

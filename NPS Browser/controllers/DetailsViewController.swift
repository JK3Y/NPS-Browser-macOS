//
//  DetailsViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 5/6/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Promises

class DetailsViewController: NSViewController {
    
    @IBOutlet weak var chkBookmark: NSButton!
    @IBOutlet weak var btnDownload: NSButton!
    @IBOutlet weak var chkDLGame: NSButton!
    @IBOutlet weak var chkDLUpdate: NSButton!
    @IBOutlet weak var chkDLCompatPack: NSButton!
    
    var windowDelegate: WindowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override var representedObject: Any? {
        didSet {
            enableBookmarkButton()
            toggleBookmark()
            enableDownloadOptions()
        }
    }

    @IBAction func btnDownloadClicked(_ sender: Any) {
//        let obj = getROManagedObject()
//        let type = obj.value(forKey: "type") as! String
//
//        var baseDLItem: DLItem? = nil
//
//        if (chkDLGame.state == .on) {
//            self.sendDLData(url: obj.value(forKey: "pkg_direct_link") as! URL, download_type: .Game)
//        }
//        if (chkDLUpdate.state == .on && chkDLUpdate.isEnabled && chkDLUpdate.isHidden == false) {
//            let url = NetworkManager().getUpdateXMLURLFromHMAC(title_id: getROManagedObject().value(forKey: "title_id") as! String)
//            let pxml = NetworkManager().fetchUpdateXML(url: url)
//            pxml().then { res in
//                self.sendDLData(url: res, download_type: .Patch)
//            }
//        }
//        if (chkDLCompatPack.state == .on && chkDLCompatPack.isEnabled && chkDLCompatPack.isHidden == false) {
//            if (type == "PS3Games" || type == "PS3DLCs" || type == "PS3Themes" || type == "PS3Avatars") {
//                sendDLData(url: getROManagedObject().value(forKey: "download_rap_file") as! URL, download_type: .RAP)
//            } else if (type == "PSVGames") {
//                let title_id = getROManagedObject().value(forKey: "title_id") as! String
//
//                if let cpacko: CompatPacksMO = Helpers().getCoreDataIO().searchCompatPacks(searchString: title_id) as? CompatPacksMO {
//                    baseDLItem = Helpers().makeDLItem(data: obj, download_link: cpacko.download_url!, download_type: .CPack)
//                }
//
//                if let cpatcho:CompatPatchMO = Helpers().getCoreDataIO().searchCompatPacks(searchString: title_id, searchPatches: true) as? CompatPatchMO {
//                    let item = Helpers().makeDLItem(data: obj, download_link: cpatcho.download_url!, download_type: .CPatch)
//                    baseDLItem?.doNext = item
//                    item.parentItem = baseDLItem
//                }
//
//                Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: baseDLItem!)
//            }
//        }
    }
    
    @IBAction func btnBookmarkToggle(_ sender: NSButton) {
        if (sender.state == .on) {
            let bookmark = Bookmark(item: getROManagedObject())
            DBManager().store(object: bookmark)
        } else {
            let bookmark = DBManager().fetch(Bookmark.self, predicate: NSPredicate(format: "uuid == %@", getROManagedObject().uuid)).first
            DBManager().delete(object: bookmark!)
        }
    }

    func enableBookmarkButton() {
        let link = getROManagedObject().pkgDirectLink
        if (link == "MISSING") {
            btnDownload.isEnabled = false
            chkBookmark.isEnabled = false
        } else {
            btnDownload.isEnabled = true
            chkBookmark.isEnabled = true
        }
    }
    
    func enableDownloadOptions() {
        let ctype: ConsoleType = ConsoleType(rawValue: getROManagedObject().consoleType!)!
        let ftype: FileType = FileType(rawValue: getROManagedObject().fileType!)!
        
        switch(ctype) {
        case .PSV:
            switch(ftype) {
            case .Game:
                let titleId = getROManagedObject().titleId
                chkDLCompatPack.title = "Compat Pack"
                chkDLGame.isEnabled = true
                chkDLUpdate.isEnabled = true
                chkDLUpdate.isHidden = false
                
                try! RealmStorageContext().fetch(CompatPack.self, predicate: NSPredicate(format: "titleId == %@", titleId!)) { result in
                    if (result.isEmpty) {
                        chkDLCompatPack.isEnabled = false
                    } else {
                        chkDLCompatPack.isEnabled = true
                        chkDLCompatPack.isHidden = false
                    }
                }
                
            default: break
            }
        case .PS3:
            let rap = getROManagedObject().rap!
            chkDLCompatPack.isHidden = false
            if (rap == "NOT REQUIRED" || rap == "UNLOCK/LICENSE BY DLC" || rap == "MISSING") {
                chkDLCompatPack.title = rap
                chkDLCompatPack.isEnabled = false
            } else {
                chkDLCompatPack.title = "RAP"
                chkDLCompatPack.isEnabled = true
            }
        default:
            chkDLUpdate.isHidden = true
            chkDLCompatPack.isHidden = true
        }
    }
    
    func toggleBookmark() {
        let predicate = NSPredicate(format: "uuid == %@", getROManagedObject().uuid)
        let bookmark = DBManager().fetch(Bookmark.self, predicate: predicate)

        if bookmark.isEmpty {
            chkBookmark.state = .off
        } else {
            chkBookmark.state = .on
        }
    }
    
    func toggleBookmark(compareUUID: String) {
        if getROManagedObject().uuid == compareUUID {
            chkBookmark.state = .off
        }
    }

    func sendDLData(url: URL, download_type: DownloadType) {
//        let obj = getROManagedObject()
//        let dlItem = Helpers().makeDLItem(data: obj, download_link: url, download_type: download_type)
//        Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: dlItem)
    }
    
    func getROManagedObject() -> Item {
        return representedObject as! Item
    }
    
//    func getBoxartViewController() -> DetailsViewController {
//        let sc: NSSplitViewController = parent?.childViewControllers[1] as! NSSplitViewController
//        let vc: DetailsViewController = sc.childViewControllers[0] as! DetailsViewController
//        return vc
//    }
}

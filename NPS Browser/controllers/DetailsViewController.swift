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
//        let bookmark: Bookmark = Helpers().makeBookmark(data: representedObject as! NSManagedObject)

//        if (sender.state == .on) {
//            Helpers().getSharedAppDelegate().bookmarkManager.addBookmark(bookmark: bookmark, item: getROManagedObject())
//        } else {
//            Helpers().getSharedAppDelegate().bookmarkManager.removeBookmark(bookmark)
//        }
    }

    func enableBookmarkButton() {
//        let link = (getROManagedObject().value(forKey: "pkg_direct_link") as! URL?)?.absoluteString
//        if (link == "MISSING") {
//            btnDownload.isEnabled = false
//            chkBookmark.isEnabled = false
//        } else {
//            btnDownload.isEnabled = true
//            chkBookmark.isEnabled = true
//        }
    }
    
    func enableDownloadOptions() {
//        let type = (getROManagedObject().value(forKey: "type") as! String)
//
//        if (type == "PSVGames") {
//            let title_id = getROManagedObject().value(forKey: "title_id") as! String
//            chkDLCompatPack.title = "Compat Pack"
//            chkDLGame.isEnabled = true
//            chkDLUpdate.isEnabled = true
//            chkDLUpdate.isHidden = false
//
//            if (Helpers().getCoreDataIO().searchCompatPacks(searchString: title_id) != nil) {
//                chkDLCompatPack.isEnabled = true
//                chkDLCompatPack.isHidden = false
//            } else {
//                chkDLCompatPack.isEnabled = false
//            }
//        }
//
//        else if (type == "PS3Games" || type == "PS3DLCs" || type == "PS3Themes" || type == "PS3Avatars") {
//            let rap = (getROManagedObject().value(forKey: "rap") as! String)
//            chkDLCompatPack.isHidden = false
//            if (rap == "NOT REQUIRED" || rap == "UNLOCK/LICENSE BY DLC" || rap == "MISSING") {
//                chkDLCompatPack.title = rap
//                chkDLCompatPack.isEnabled = false
//            } else {
//                chkDLCompatPack.title = "RAP"
//                chkDLCompatPack.isEnabled = true
//            }
//        }
//
//        else {
//            chkDLUpdate.isHidden = true
//            chkDLCompatPack.isHidden = true
//        }
    }
    
    func toggleBookmark() {
//        let bookmark = Helpers().getCoreDataIO().getRecordByUUID(entityName: "Bookmarks", uuid: getROManagedObject().value(forKey: "uuid") as! UUID)
//        
//        if ( bookmark != nil) {
//            chkBookmark.state = .on
//        } else {
//            chkBookmark.state = .off
//        }
    }
    
    func toggleBookmark(compareUUID: UUID) {
//        let obj: NSUUID = getROManagedObject().value(forKey: "uuid") as! NSUUID
//        if (obj.isEqual(to: (compareUUID as NSUUID))) {
//            chkBookmark.state = .off
//        }
    }

    func sendDLData(url: URL, download_type: DownloadType) {
//        let obj = getROManagedObject()
//        let dlItem = Helpers().makeDLItem(data: obj, download_link: url, download_type: download_type)
//        Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: dlItem)
    }
    
//    func getROManagedObject() -> NPSItem {
//
//        debugPrint(representedObject)
//        return representedObject as! NPSItem
//    }
    
//    func getBoxartViewController() -> DetailsViewController {
//        let sc: NSSplitViewController = parent?.childViewControllers[1] as! NSSplitViewController
//        let vc: DetailsViewController = sc.childViewControllers[0] as! DetailsViewController
//        return vc
//    }
}

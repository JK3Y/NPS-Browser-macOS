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

    override var representedObject: Any? {
        didSet {
            enableBookmarkButton()
            toggleBookmark()
            enableDownloadOptions()
            
            getBoxartViewController().representedObject = representedObject
        }
    }

    @IBAction func btnDownloadClicked(_ sender: Any) {
        let obj = getROManagedObject()

        var baseDLItem: DLItem? = nil

        if (chkDLGame.state == .on) {
            let url = try? obj.pkgDirectLink!.asURL()
            self.sendDLData(url: url!, fileType: .Game)
        }
        if (chkDLUpdate.state == .on && chkDLUpdate.isEnabled && chkDLUpdate.isHidden == false) {
            let url = NetworkManager().getUpdateXMLURLFromHMAC(titleId: getROManagedObject().titleId!)
            let pxml = NetworkManager().fetchUpdateXML(url: url)
            pxml().then { res in
                self.sendDLData(url: res, fileType: .Update)
            }
        }
        if (chkDLCompatPack.state == .on && chkDLCompatPack.isEnabled && chkDLCompatPack.isHidden == false) {
            let ct: ConsoleType = ConsoleType(rawValue: obj.consoleType!)!
            let ft: FileType = FileType(rawValue: obj.fileType!)!
            switch(ct) {
            case .PS3:
                let url = URL(string: obj.downloadRapFile!)
                sendDLData(url: url!, fileType: .RAP)
            case .PSV:
                switch(ft) {
                case .Game:
                    let titleId = obj.titleId
                    
                    if let cpacko: CompatPack = DBManager().fetch(CompatPack.self, predicate: NSPredicate(format: "titleId == %@ AND type == 'CompatPack'", titleId!), sorted: nil).first {
                        let url = URL(string: (cpacko.downloadUrl)!)
                        baseDLItem = Helpers().makeDLItem(data: obj, downloadUrl: url!, fileType: .CPack)
                    }
                    
                    if let cpatcho: CompatPack = DBManager().fetch(CompatPack.self, predicate: NSPredicate(format: "titleId == %@ AND type == 'CompatPatch'", titleId!), sorted: nil).first {
                        let url = URL(string: (cpatcho.downloadUrl)!)
                        let item = Helpers().makeDLItem(data: obj, downloadUrl: url!, fileType: .CPatch)
                        baseDLItem?.doNext = item
                        item.parentItem = baseDLItem
                    }
                    
                    Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: baseDLItem!)
                default: break
                }
            default: break
            }
        }
    }
    
    @IBAction func btnBookmarkToggle(_ sender: NSButton) {
        if (sender.state == .on) {
            let bookmark = Bookmark(item: getROManagedObject())
            DBManager().store(object: bookmark)
        } else {
            let bookmark = DBManager().fetch(Bookmark.self, predicate: NSPredicate(format: "uuid == %@", getROManagedObject().pk)).first
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
        
        chkDLGame.title = ftype.rawValue
        
        switch(ctype) {
        case .PSV:
            switch(ftype) {
            case .Game:
                let titleId = getROManagedObject().titleId
                chkDLCompatPack.title = "CPack"
                chkDLGame.isEnabled = true
                chkDLUpdate.isEnabled = true
                chkDLUpdate.isHidden = false
                chkDLCompatPack.isHidden = false
                
                try! RealmStorageContext().fetch(CompatPack.self, predicate: NSPredicate(format: "titleId == %@", titleId!)) { result in
                    if (result.isEmpty) {
                        chkDLCompatPack.isEnabled = false
                    } else {
                        chkDLCompatPack.isEnabled = true
                    }
                }
            default:
                chkDLCompatPack.isHidden = true
                chkDLCompatPack.isEnabled = false
                chkDLUpdate.isHidden = true
                chkDLUpdate.isEnabled = false
            }
        case .PS3:
            let rap = getROManagedObject().rap!
            chkDLCompatPack.isHidden = false
            chkDLUpdate.isHidden = true
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
        let predicate = NSPredicate(format: "uuid == %@", getROManagedObject().pk)
        let bookmark = DBManager().fetch(Bookmark.self, predicate: predicate)

        if bookmark.isEmpty {
            chkBookmark.state = .off
        } else {
            chkBookmark.state = .on
        }
    }
    
    func toggleBookmark(comparePK: String) {
        if getROManagedObject().pk == comparePK {
            chkBookmark.state = .off
        }
    }

    func sendDLData(url: URL, fileType: FileType) {
        let obj = getROManagedObject()
        let dlItem = Helpers().makeDLItem(data: obj, downloadUrl: url, fileType: fileType)
        Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: dlItem)
    }
    
    func getROManagedObject() -> Item {
        return representedObject as! Item
    }
    
    func getBoxartViewController() -> GameArtworkViewController {
      let vc: GameArtworkViewController = parent?.children[1] as! GameArtworkViewController
        return vc
    }
}

//
//  Helpers.swift
//  NPS Browser
//
//  Created by JK3Y on 6/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Foundation

class Helpers {
    
    func makeAlert(messageText: String = "", informativeText: String = "", alertStyle: NSAlert.Style = .warning) {
        let alert = NSAlert()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.alertStyle = alertStyle
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    func makeNotification(title: String, subtitle: String) {
        getSharedAppDelegate().showNotification(title: title, subtitle: subtitle)
    }
    
    func getSharedAppDelegate() -> AppDelegate {
        return NSApp.delegate as! AppDelegate
    }
    
    func getWindowDelegate() -> WindowDelegate {
        return NSApp.windows.first?.windowController as! WindowController
    }
    
    func getDataController() -> DataViewController {
        return getWindowDelegate().getDataController()
    }
    
    func getCoreDataIO() -> CoreDataIO {
        return getSharedAppDelegate().coreDataIO
    }
    
    func getLoadingViewController() -> LoadingViewController {
        return getWindowDelegate().getLoadingViewController()
    }
    
    func showLoadingViewController() {
        getDataController().presentViewControllerAsSheet(getWindowDelegate().getLoadingViewController())
    }
    
    
    
    func getRowObjectFromTableRowButton(_ sender: NSButton) -> Any? {
        var superView = sender.superview
        while let view = superView, !(view is NSTableCellView) {
            superView = view.superview
        }
        guard let cell = superView as? NSTableCellView else {
            print("Sender is not in a table view cell!")
            return nil
        }
        
        return cell.objectValue
    }

    func makeBookmark(data: NSManagedObject) -> Bookmark {
        if (data.entity.name == "Bookmarks") {
            return Bookmark(name: data.value(forKey: "name") as! String,
                            title_id: data.value(forKey: "title_id") as! String,
                            type: data.value(forKey: "type") as! String,
                            zrif: data.value(forKey: "zrif") as? String ?? nil,
                            download_link: data.value(forKey: "download_link") as? URL,
                            uuid: data.value(forKey: "uuid") as! UUID)
        } else if (data.entity.name == "PSVGames" ||
            data.entity.name == "PSVDLCs" ||
            data.entity.name == "PSVThemes") {
            return Bookmark(name: data.value(forKey: "name") as! String,
                            title_id: data.value(forKey: "title_id") as! String,
                            type: data.value(forKey: "type") as! String,
                            zrif: data.value(forKey: "zrif") as? String,
                            download_link: data.value(forKey: "pkg_direct_link") as? URL,
                            uuid: data.value(forKey: "uuid") as! UUID)
        } else {
            return Bookmark(name: data.value(forKey: "name") as! String,
                            title_id: data.value(forKey: "title_id") as! String,
                            type: data.value(forKey: "type") as! String,
                            zrif: nil,
                            download_link: data.value(forKey: "pkg_direct_link") as? URL,
                            uuid: data.value(forKey: "uuid") as! UUID)
        }
    }
    
    func makeDLItem(data: NSManagedObject, download_link: URL) -> DLItem {
        let type = data.value(forKey: "type") as? String ?? getWindowDelegate().getType()
        let obj = DLItem()

        obj.type = type
        obj.title_id        = data.value(forKey: "title_id") as! String? ?? ""
        obj.name            = data.value(forKey: "name") as! String? ?? ""
        obj.download_link = download_link

        switch(type) {
        case "PSVGames":
            obj.zrif = (data as! PSVGameMO).zrif ?? ""
            break
        case "PSVDLCs":
            obj.zrif = (data as! PSVDLCMO).zrif ?? ""
            break
        default:
            break
        }
        return obj
    }
}

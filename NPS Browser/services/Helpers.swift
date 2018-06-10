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
        (NSApplication.shared.delegate as! AppDelegate).showNotification(title: title, subtitle: subtitle)
    }
    
    func getSharedAppDelegate() -> AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    func getWindowDelegate() -> WindowDelegate {
        return NSApplication.shared.mainWindow?.windowController as! WindowController
    }
    
    func getDataController() -> DataViewController {
        return getWindowDelegate().getDataController()
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
    

    func makeBookmark(rowData: Any) -> Bookmark {
        let data = makeDLItem(data: rowData)
        return Bookmark(name: data.name!, title_id: data.title_id!, type: data.type!, zrif: data.zrif, url: data.url)
    }
    
    func makeDLItem(data: Any?) -> DLItem {
        let type = getWindowDelegate().getType()
        
        let obj = DLItem()
        obj.type = type
        
        switch(type) {
        case "PSVGames":
            obj.title_id = (data! as! PSVGameMO).title_id ?? ""
            obj.name = (data! as! PSVGameMO).name ?? ""
            obj.url = URL(string: ((data! as! PSVGameMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            obj.zrif = (data! as! PSVGameMO).zrif ?? ""
            
//            obj.objectID = (data! as! PSVGameMO).objectID
            break
        case "PSVUpdates":
            obj.title_id = (data! as! PSVUpdateMO).title_id ?? ""
            obj.name = (data! as! PSVUpdateMO).name ?? ""
            obj.url = URL(string: ((data! as! PSVUpdateMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            break
        case "PSVDLCs":
            obj.title_id = (data! as! PSVDLCMO).title_id ?? ""
            obj.name = (data! as! PSVDLCMO).name ?? ""
            obj.url = URL(string: ((data! as! PSVDLCMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            obj.zrif = (data! as! PSVDLCMO).zrif ?? ""
            break
        case "PSPGames":
            obj.title_id = (data! as! PSPGameMO).title_id ?? ""
            obj.name = (data! as! PSPGameMO).name ?? ""
            obj.url = URL(string: ((data! as! PSPGameMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            break
        case "PSXGames":
            obj.title_id = (data! as! PSXGameMO).title_id ?? ""
            obj.name = (data! as! PSXGameMO).name ?? ""
            obj.url = URL(string: ((data! as! PSXGameMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            break
        default:
            break
        }
        return obj
    }
    
}

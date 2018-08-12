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
    
    func makeDLItem(data: Item, downloadUrl: URL, fileType: FileType) -> DLItem {
        let obj = DLItem()
        let ctype: ConsoleType = ConsoleType.init(rawValue: data.consoleType!)!

        obj.titleId        = data.titleId
        obj.name            = "\(fileType.rawValue) - \(data.name!)"
        obj.downloadUrl   = downloadUrl
        obj.zrif = data.zrif
        obj.consoleType = data.consoleType
        obj.fileType = fileType.rawValue

        return obj
    }
}

//
//  AppDelegate.swift
//  NPS Browser
//
//  Created by JK3Y on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Files
import SwiftyBeaver
import RealmSwift

let log = SwiftyBeaver.self

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    lazy var downloadManager: DownloadManager = DownloadManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupSwiftyBeaverLogging()
        setupDownloadsDirectory()
        
//        populateMasterTable()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        downloadManager.stopAndStoreDownloadList()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
//    func populateMasterTable() {
//        let it = Helpers().getWindowDelegate().getItemType()
//        let ct = it.console.rawValue
//        let ft = it.fileType.rawValue
//        let reg = Helpers().getWindowDelegate().getRegion()
//
//        var items = try! Realm().objects(Item.self)
//        if (items.isEmpty) {
//            NetworkManager().makeRequest()
//        } else {
//            Helpers().getDataController().setArrayControllerContent(content: items.filter(NSPredicate(format: "consoleType == %@ AND fileType == %@ AND region == %@ AND pkgDirectLink != 'MISSING'", ct, ft, reg)))
//            
//            Helpers().getDataController().items = items
//        }
//    }
    
    func setupSwiftyBeaverLogging() {
        let console = ConsoleDestination()
        let file = FileDestination()

        log.addDestination(console)
        log.addDestination(file)
    }
    
    func setupDownloadsDirectory() {
        let dlFolder = SettingsManager().getDownloads().library_location
        let dlDirName = "NPS Downloads"
        
        try! Folder(path: dlFolder.path).createSubfolderIfNeeded(withName: dlDirName)
    }
    
    // MARK: - Notifications
    
    func showNotification(title: String, subtitle: String) {
        let notification = NSUserNotification()
        
        notification.title = title
        notification.subtitle = subtitle
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

}


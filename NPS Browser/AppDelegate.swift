//
//  AppDelegate.swift
//  NPS Browser
//
//  Created by JK3Y on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import SwiftyBeaver
import RealmSwift
import SwiftyUserDefaults

let log = SwiftyBeaver.self

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    lazy var downloadManager: DownloadManager = DownloadManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupSwiftyBeaverLogging()
        setupDownloadsDirectory()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        downloadManager.stopAndStoreDownloadList()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func setupSwiftyBeaverLogging() {
        let console = ConsoleDestination()
        let file = FileDestination()

        log.addDestination(console)
        log.addDestination(file)
    }
    
    func setupDownloadsDirectory() {
        var dlFolder: URL? = Defaults[.dl_library_location]
        
        
//        if (try! !dlFolder.checkResourceIsReachable()) {
//            dlFolder =
//            try! Defaults[.dl_library_location] = dlFolder
//        }
        
        let dlDirName = "NPS Downloads"
        
        do {
            try Folder(path: dlFolder!.path).createSubfolderIfNeeded(withName: dlDirName)
        } catch {
            dlFolder = try! NSHomeDirectory().asURL().appendingPathComponent("Downloads")
            Defaults.set(dlFolder!.absoluteURL, forKey: "dl_library_location")
            try! Folder(path: dlFolder!.path).createSubfolderIfNeeded(withName: dlDirName)
        }
        
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


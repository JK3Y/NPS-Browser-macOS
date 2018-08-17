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
        checkUpdateSettings()
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
        let dlFolder = SettingsManager().getDownloads().library_location
        let dlDirName = "NPS Downloads"
        
        try! Folder(path: dlFolder.path).createSubfolderIfNeeded(withName: dlDirName)
    }
    
    func checkUpdateSettings() {
        let settings = SettingsManager().getUpdate()
        if settings.automatically_check {
            AppUpdateChecker().fetchLatest() { ghVersion, browserDownloadURL in
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    let downloadUrl: URL = URL(string: browserDownloadURL)!
                    
                    if appVersion < ghVersion {
                        let alert = NSAlert()
                        alert.messageText = "Update Available"
                        alert.informativeText = "A new version is available!"
                        alert.alertStyle = .informational
                        alert.addButton(withTitle: "Download")
                        alert.addButton(withTitle: "Cancel")
                        let responseTag = alert.runModal()
                        
                        if responseTag.rawValue == 1000 {
                            AppUpdateChecker().downloadUpdate(url: downloadUrl)
                            log.info("Downloading update")
                        }
                    }
                }
            }
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


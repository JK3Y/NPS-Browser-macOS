//
//  ExtractionManager.swift
//  NPS Browser
//
//  Created by JK3Y on 6/2/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Cocoa

class ExtractionManager {
    private var item: DLItem
    private let userSettings = SettingsManager().getSettings()
    private var downloadManager: DownloadManager
    private var isPS3: Bool = false
    
    init(item: DLItem, downloadManager: DownloadManager) {
        self.item = item
        if (item.type == "PS3Games") {
            self.isPS3 = true
        }
        self.downloadManager = downloadManager
    }
    
    func start() {
        if (!shouldDoExtract()) {
            setStatus("Download Complete")
            self.item.makeViewable()
            Helpers().makeNotification(title: self.item.name!, subtitle: self.item.status!)
            
            downloadManager.moveToCompleted(item: self.item)
            return
        }

        setStatus("Extracting...")

        let pkg2zipPath = Bundle.main.resourcePath! + "/pkg2zip"
        let task = Process()
        let pipe = Pipe()

        task.currentDirectoryURL = userSettings?.download.download_location
        task.executableURL = URL(fileURLWithPath: pkg2zipPath)

        task.arguments = getArguments()
        task.standardOutput = pipe
        task.terminationHandler = { task in
            DispatchQueue.main.async {
                self.setStatus("Extraction Complete")
                self.item.makeViewable()
                Helpers().makeNotification(title: self.item.name!, subtitle: self.item.status!)
            }
        }
        
        do {
            try task.run()
        } catch let error as NSError {
            debugPrint(error)
        }
        
        task.waitUntilExit()
        
        cleanup()
    }
    
    private func shouldDoExtract() -> Bool {
        if (isPS3) {
            return false
        }
        return userSettings!.extract.extract_after_downloading
    }
    
    private func cleanup() {
        if (!(userSettings?.extract.keep_pkg)!) { // false
            let pkg_path = item.destinationURL
            do {
                try FileManager.default.removeItem(at: pkg_path!)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
    }
    
    private func getArguments() -> [String] {
        // pkg2zip args: [zip (nothing) or not (-x)] [.pkg path] [zRIF string]
        var arguments: [String] = []
        let extractSettings = userSettings?.extract
        
        if (!(extractSettings?.save_as_zip)!) { // == false
            arguments.append("-x")
        }
        
        if (item.type! == "PSPGames" && (extractSettings?.compress_psp_iso)!) { // == true
            arguments.append("-c\(extractSettings?.compression_factor ?? 1)")
        }
        
        arguments.append((item.destinationURL?.path)!)
        
        if (item.zrif != nil && (extractSettings?.create_license)!) { // == true
            arguments.append(item.zrif!)
        }
        
        return arguments
    }
    
//    private func unpackagePS3() {
//        setStatus("Extracting...")
//
//        let pkgripPath = Bundle.main.resourcePath! + "/pkgrip"
//        let task = Process()
//        let pipe = Pipe()
//
//        task.currentDirectoryURL = userSettings?.download.download_location
//        task.executableURL = URL(fileURLWithPath: pkgripPath)
//        task.arguments = ["-s", (item.destinationURL?.path)!]
//        task.standardOutput = pipe
//        task.terminationHandler = { task in
//            DispatchQueue.main.async {
//                self.setStatus("Extraction Complete")
//                self.item.makeViewable()
//                Helpers().makeNotification(title: self.item.name!, subtitle: self.item.status!)
//            }
//        }
//
//        do {
//            try task.run()
//        } catch let error as NSError {
//            debugPrint(error)
//        }
//
//        task.waitUntilExit()
//
//        cleanup()
//    }
    
    private func setStatus(_ status: String) {
        item.status = status
    }
}

//
//  ExtractionManager.swift
//  NPS Browser
//
//  Created by JK3Y on 6/2/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Cocoa
import Zip
import Files

class ExtractionManager {
    private var item: DLItem
    private let userSettings = SettingsManager().getSettings()
    private var downloadManager: DownloadManager
    private var isPS3: Bool = false
    
    init(item: DLItem, downloadManager: DownloadManager) {
        self.item = item
        Zip.addCustomFileExtension("ppk")

        if (item.type == "PS3Games" || item.type == "PS3DLCs" || item.type == "PS3Themes" || item.type == "PS3Avatars") {
            self.isPS3 = true
        }
    
        self.downloadManager = downloadManager
    }
    
    func start() {
        if (!shouldDoExtract()) {
            completeDownload(status: "Download Complete")
            return
        }
        
        if (item.download_type == "CPatch" || item.download_type == "CPack") {
            unzipPPK()
        } else {
            usePkg2Zip()
        }
    }
    
    func unzipPPK() {
        var filepath = SettingsManager().getDownloads().download_location
        try! Folder(path: filepath.path).createSubfolderIfNeeded(withName: "rePatch")
        
        filepath = filepath.appendingPathComponent("rePatch/\(item.title_id!)")
        if (item.download_type == "CPack") {
            do {
                log.debug("filepath: \(filepath)")
                try Zip.unzipFile(item.destinationURL!, destination: filepath, overwrite: true, password: nil)
            }
            catch {
                log.warning("pack not unzipped")
            }
        }
        
        if (item.download_type == "CPatch") {
            do {
                log.debug("filepath: \(filepath)")
                
                if (item.cpackPath != nil) {
                    try Zip.unzipFile(item.cpackPath!, destination: filepath, overwrite: true, password: nil)
                    item.parentItem?.status = "Extraction Complete"
                    item.parentItem?.makeViewable()
                    Helpers().makeNotification(title: (item.parentItem?.name!)!, subtitle: (item.parentItem?.status!)!)
                }
                try Zip.unzipFile(item.destinationURL!, destination: filepath, overwrite: true, password: nil)
                completeDownload(status: "Extraction Complete")
            }
            catch {
                log.warning("patch not unzipped")
            }
        }
    }
    
    func usePkg2Zip() {
        if (item.zrif == "MISSING") {
            completeDownload(status: "Missing zRIF, license not created")
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
                
                let taskStatus = task.terminationStatus
                
                if (taskStatus == 0) {
                    debugPrint("Success!")
                    
                    self.setStatus("Extraction Complete")
                    self.item.makeViewable()
                    Helpers().makeNotification(title: self.item.name!, subtitle: self.item.status!)
                } else {
                    debugPrint("Task Failed")
                }
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
    
    private func completeDownload(status: String) {
        setStatus(status)
        self.item.makeViewable()
        Helpers().makeNotification(title: self.item.name!, subtitle: self.item.status!)
        
        downloadManager.moveToCompleted(item: self.item)
        return
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

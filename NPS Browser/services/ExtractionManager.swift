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
//import Files
import SwiftyUserDefaults

class ExtractionManager {
    private var item: DLItem
//    private let userSettings = SettingsManager().getSettings()
    private var downloadManager: DownloadManager
    private var isPS3: Bool = false
    
    init(item: DLItem, downloadManager: DownloadManager) {
        self.item = item
        Zip.addCustomFileExtension("ppk")

        if (item.consoleType == "PS3") {
            self.isPS3 = true
        }
    
        self.downloadManager = downloadManager
    }
    
    func start() {
        if (!shouldDoExtract()) {
            completeDownload(status: "Download Complete")
            return
        }
        
        if (item.fileType == "CPatch" || item.fileType == "CPack") {
            unzipPPK()
        } else {
            usePkg2Zip()
        }
    }
    
    func makeRepatchFolder(filepath: URL) -> URL {
        let fp = filepath.appendingPathComponent(item.consoleType!)
        try! Folder(path: fp.path).createSubfolderIfNeeded(withName: "rePatch")
        
        return fp.appendingPathComponent("rePatch")
    }
    
    func unzipPPK() {
        var filepath = Defaults[.xt_library_folder]
        let rpf = makeRepatchFolder(filepath: filepath!)
        filepath = rpf.appendingPathComponent("\(item.titleId!)")
        
        if (item.fileType == "CPack") {
            do {
                try Zip.unzipFile(item.destinationURL!, destination: filepath!, overwrite: true, password: nil)
                completeDownload(status: "Extraction Complete")
            }
            catch {
                log.warning("pack not unzipped")
            }
        }
        
        if (item.fileType == "CPatch") {
            do {
                if (item.cpackPath != nil) {
                    try Zip.unzipFile(item.cpackPath!, destination: filepath!, overwrite: true, password: nil)
                    item.parentItem?.status = "Extraction Complete"
                    item.parentItem?.makeViewable()
                    Helpers().makeNotification(title: (item.parentItem?.name!)!, subtitle: (item.parentItem?.status!)!)
                }
                try Zip.unzipFile(item.destinationURL!, destination: filepath!, overwrite: true, password: nil)
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
        
        let pkg2zipPath = Bundle.main.path(forResource: "pkg2zip", ofType: nil)
        let task = Process()
        let pipe = Pipe()
        
        task.currentDirectoryPath = (Defaults[.xt_library_folder]?.appendingPathComponent(item.consoleType!).path)!

        task.launchPath = pkg2zipPath
        
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
            try task.launch()
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
        return Defaults[.xt_extract_after_downloading]
    }
    
    private func cleanup() {
        if (!(Defaults[.xt_keep_pkg])) { // false
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
        
        if (!(Defaults[.xt_save_as_zip])) { // == false
            arguments.append("-x")
        }
        
        if (item.consoleType! == "PSP" && item.fileType! == "Game" && Defaults[.xt_compress_psp_iso]) { // == true
            arguments.append("-c\(Defaults[.xt_compression_factor] ?? 1)")
        }
        
        arguments.append((item.destinationURL?.path)!)
        
        if (item.zrif != nil && Defaults[.xt_create_license]) { // == true
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

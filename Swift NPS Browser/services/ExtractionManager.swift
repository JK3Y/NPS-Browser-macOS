//
//  ExtractionManager.swift
//  NPS Browser
//
//  Created by Jacob Amador on 6/2/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation

class ExtractionManager {
    private var item: DLItem
    private let userSettings = SettingsManager().getSettings()
    
    init(item: DLItem) {
        self.item = item
    }
    
    func start() {
        if (!shouldDoExtract()) {
            setStatus("Complete")
            self.item.isViewable = true
            self.item.isRemovable = true
            self.item.isCancelable = false
            return
        }
        
        setStatus("Extracting...")

        let pkg2zipPath = Bundle.main.resourcePath! + "/pkg2zip"
        let task = Process()
        let pipe = Pipe()
        
        task.currentDirectoryURL = userSettings?.downloads["download_location"]
        task.executableURL = URL(fileURLWithPath: pkg2zipPath)
        task.arguments = getArguments()
        task.standardOutput = pipe
        task.terminationHandler = { task in
            DispatchQueue.main.async {
                self.setStatus("Complete")
                self.item.isViewable = true
                self.item.isRemovable = true
                self.item.isCancelable = false
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
        if (userSettings?.extract["extract_after_downloading"])! {
            return true
        } else {
            return false
        }
    }
    
    private func cleanup() {
        if (!(userSettings?.extract["keep_pkg"])!) { // == false
            let pkgPath = item.destinationURL
            do {
                try FileManager.default.removeItem(at: pkgPath!)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
    }
    
    private func getArguments() -> [String] {
        // pkg2zip args: [zip (nothing) or not (-x)] [.pkg path] [zRIF string]
        var arguments: [String] = []
        let extractSettings = userSettings?.extract
        
        if (!extractSettings!["save_as_zip"]!) { // == false
            arguments.append("-x")
        }
        
        if (item.type! == "PSPGames" && extractSettings!["compress_psp_iso"]!) { // == true
            arguments.append("-c\(userSettings?.compressionFactor ?? 1)")
        }
        
        arguments.append((item.destinationURL?.path)!)
        
        if (item.zrif != nil && extractSettings!["create_license"]!) { // == true
            arguments.append(item.zrif!)
        }
        
        return arguments
    }
    
    private func setStatus(_ status: String) {
        item.status = status
    }
}

//
//  DownloadManager.swift
//  NPS Browser
//
//  Created by JK3Y on 5/18/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Queuer
import Alamofire
import Promises
import Files

class DownloadManager {
    
    var downloadItems: [DLItem] = []
    let queue = Queuer(name: "DLQueue", maxConcurrentOperationCount: SettingsManager().getDownloads().concurrent_downloads, qualityOfService: .default)
    
    init() {
        restoreDownloadList()
    }
    
    func getDestination(data: DLItem) -> DownloadRequest.DownloadFileDestination {
        let destination: DownloadRequest.DownloadFileDestination = { request, response in
            // .pkg filename
            let pathComponent = response.suggestedFilename!
            let downloadSettings = SettingsManager().getDownloads()
            let cf = data.getConsole()
            var path: URL = downloadSettings.download_location.appendingPathComponent(cf)
            path.appendPathComponent(pathComponent)
            return (path, [.removePreviousFile, .createIntermediateDirectories])
        }
        return destination
    }
    
    func makeConsoleFolder(dlItem: DLItem) {
        let filepath = SettingsManager().getDownloads().download_location
        let console = dlItem.getConsole()
        try! Folder(path: filepath.path).createSubfolderIfNeeded(withName: console)
    }
    
    func addToDownloadQueue(data: DLItem) {
        // store request in same object so we can cancel/pause/resume it later
        let destination = getDestination(data: data)
        
        makeConsoleFolder(dlItem: data)
        
        let request = Alamofire.download(data.download_link!, to: destination)
        data.request = request
        data.destination = destination
            
        // add object to downloadItems array
        downloadItems.insert(data, at: 0)
        
        let downloadItemsIndex = downloadItems.index(of: data)!
        
        // get object back out of downloadItems array so the async operation can use it and update the properties as it runs
        let dlItem = self.downloadItems[downloadItemsIndex]
        
        let dlFileOperation = makeConucurrentOperation(dlItem: dlItem, request: request)
        self.queue.addOperation(dlFileOperation)
    }
    
    func resumeDownload(data: DLItem) {
        let request = Alamofire.download(resumingWith: data.resumeData!, to: data.destination)
        data.request = request
        let op = makeConucurrentOperation(dlItem: data, request: request)
        queue.addOperation(op)
    }

    func removeCompleted() {
        for item in downloadItems {
            if (item.isRemovable) {
                downloadItems.remove(at: downloadItems.index(of: item)!)
            }
        }
    }
    
    func moveToCompleted(item: DLItem) {
        downloadItems.remove(at: downloadItems.index(of: item)!)
        downloadItems.insert(item, at: downloadItems.endIndex)
    }
    
    func getObjectQueue() -> [DLItem] {
        return self.downloadItems
    }
    
    func stopAndStoreDownloadList() {
        for item in downloadItems {
            
            if (item.status == "Download Complete" || item.status == "Extraction Complete" || item.status == "Missing zRIF, license not created") {
                item.makeViewable()
            } else {
                item.request?.cancel()
                item.makeResumable()
            }
        }
        let downloadList: DownloadList = DownloadList(items: downloadItems)
        
        do {
            let data = try PropertyListEncoder().encode(downloadList)
            UserDefaults.standard.set(data, forKey: "downloads")
        } catch {
            Helpers().makeAlert(messageText: "Save Failed",
                                informativeText: "Download list could not be stored.",
                                alertStyle: .warning)
        }
    }
    
    func restoreDownloadList() {
        let storedData = UserDefaults.standard.object(forKey: "downloads") as? Data
        if (storedData != nil) {
            do {
                let downloadList = try PropertyListDecoder().decode(DownloadList.self, from: storedData!)

                self.downloadItems = downloadList.items
            } catch let error as NSError {
                debugPrint(error)
            }
        }
    }

    func makeConucurrentOperation(dlItem: DLItem, request: DownloadRequest) -> ConcurrentOperation {
        return ConcurrentOperation {
            dlItem.status = "Queued..."
            
            request.downloadProgress { progress in
                dlItem.status = "Downloading..."
                dlItem.makeCancelable()
                dlItem.progress = (progress.fractionCompleted * 100).rounded()
                dlItem.timeRemaining = progress.fractionCompleted
                }
                .responseData { response in
                    response.result.ifSuccess {
                        dlItem.destinationURL = response.destinationURL
                        if (dlItem.isMore()) {
                            dlItem.doNext?.cpackPath = dlItem.destinationURL
                            dlItem.status = "Waiting..."

                            self.addToDownloadQueue(data: dlItem.doNext!)
                        } else {
                            ExtractionManager(item: dlItem, downloadManager: self).start()
                        }
                    }
                    response.result.ifFailure {
                        guard let resumeData = response.resumeData else {
                            dlItem.status = "Failed! \(response.error.debugDescription)"
                            dlItem.makeRemovable()
                            return
                        }
                        dlItem.status = "Stopped"
                        dlItem.resumeData = resumeData
                        dlItem.makeResumable()
                    }
            }
        }
    }
}

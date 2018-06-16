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

class DownloadManager {
    
    var downloadItems: [DLItem] = []
    let queue = Queuer(name: "DLQueue", maxConcurrentOperationCount: SettingsManager().getDownloads().concurrent_downloads, qualityOfService: .default)
    
    init() {}
    
    func addToDownloadQueue(data: DLItem) {
        // create destination for file
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            // .pkg filename
            let pathComponent = response.suggestedFilename!
            let downloadSettings = SettingsManager().getDownloads()
            var path: URL = downloadSettings.download_location
            path.appendPathComponent(pathComponent)
            return (path, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        // store request in same object so we can cancel/pause/resume it later
        let request = Alamofire.download(data.pkg_direct_link!, to: destination)
        data.request = request
        
        // add object to downloadItems array
        downloadItems.insert(data, at: 0)
        
        let downloadItemsIndex = downloadItems.index(of: data)!
        
        // get object back out of downloadItems array so the async operation can use it and update the properties as it runs
        let dlItem = self.downloadItems[downloadItemsIndex]
        
        let dlFileOperation = ConcurrentOperation {
            request.downloadProgress { progress in
                dlItem.status = "Downloading..."        
                dlItem.makeCancelable()
                dlItem.progress = (progress.fractionCompleted * 100).rounded()
                dlItem.timeRemaining = progress.fractionCompleted
            }
            .responseData { response in
                response.result.ifSuccess {

                    dlItem.destinationURL = response.destinationURL

                    ExtractionManager(item: dlItem, downloadManager: self).start()
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
        self.queue.addOperation(dlFileOperation)
    }
    
    func resumeDownload(data: DLItem) {
        let request = Alamofire.download(resumingWith: data.resumeData!)
        data.request = request
        
        request.downloadProgress { progress in
            data.status = "Downloading..."
            data.makeCancelable()
            data.progress = (progress.fractionCompleted * 100).rounded()
            data.timeRemaining = progress.fractionCompleted
        }
            .responseData { response in
                response.result.ifSuccess {
                    ExtractionManager(item: data, downloadManager: self).start()
                }
                response.result.ifFailure {
                    guard let resumeData = response.resumeData else {
                        data.status = "Failed! \(response.error.debugDescription)"
                        data.makeRemovable()
                        return
                    }
                    data.status = "Stopped"
                    data.resumeData = resumeData
                    data.makeResumable()
                }
        }
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
}

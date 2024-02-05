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
//import Files
import SwiftyUserDefaults

class DownloadManager {
    
    var downloadItems: [DLItem] = []
    let queue = Queuer(name: "DLQueue", maxConcurrentOperationCount: Defaults[.dl_concurrent_downloads], qualityOfService: .default)
    
    init() {
        restoreDownloadList()
    }
    
    func getDestination(data: DLItem) -> DownloadRequest.DownloadFileDestination {
        let destination: DownloadRequest.DownloadFileDestination = { request, response in
            // .pkg filename
            let pathComponent = response.suggestedFilename!
            let cf = data.consoleType
            
            var path: URL = Defaults[.dl_library_folder] ?? URL(string: try! Folder.home.subfolder(named: "Downloads").path)!
            
            path.appendPathComponent(cf!)
//            var path: URL = Defaults[.dl_library_folder]!.appendingPathComponent(cf!)
            path.appendPathComponent(pathComponent)

            let decodedurl = path.path.removingPercentEncoding
            let url = URL(fileURLWithPath: decodedurl!)
            return (url, [.removePreviousFile, .createIntermediateDirectories])
        }
        return destination
    }
    
    func makeConsoleFolder(dlItem: DLItem) {
        let filepath = Defaults[.dl_library_folder]!
        let console = dlItem.consoleType

        if (try? Folder(path: filepath.path).createSubfolderIfNeeded(withName: console!)) != nil {
            return
        } else {
            Helpers.setupDownloadsDirectory()
            makeConsoleFolder(dlItem: dlItem)
        }
    }
    
    func addToDownloadQueue(data: DLItem) {
        // store request in same object so we can cancel/pause/resume it later
        let destination = getDestination(data: data)
        
        makeConsoleFolder(dlItem: data)
        
        let request = Alamofire.download(data.downloadUrl!, to: destination)
        data.request = request
        data.destination = destination
            
        // add object to downloadItems array
        downloadItems.insert(data, at: 0)
        
        let downloadItemsIndex = downloadItems.firstIndex(of: data)!
        
        // get object back out of downloadItems array so the async operation can use it and update the properties as it runs
        let dlItem = self.downloadItems[downloadItemsIndex]
        
        let dlFileOperation = makeConcurrentOperation(dlItem: dlItem, request: request)
        self.queue.addOperation(dlFileOperation)
    }
    
    func resumeDownload(data: DLItem) {
      if let resumeData = data.resumeData {
          let request = Alamofire.download(resumingWith: resumeData, to: data.destination)

          data.request = request
          let op = makeConcurrentOperation(dlItem: data, request: request)
          queue.addOperation(op)
      }
    }

    func removeCompleted() {
        for item in downloadItems {
            if (item.isRemovable) {
              downloadItems.remove(at: downloadItems.firstIndex(of: item)!)
            }
        }
    }
    
    func moveToCompleted(item: DLItem) {
        downloadItems.remove(at: downloadItems.firstIndex(of: item)!)
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
                item.status = "Stopped"
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
            
            log.error("Save Failed. Download list could not be stored.")
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
                
                log.error(error)
            }
        }
    }

    func makeConcurrentOperation(dlItem: DLItem, request: DownloadRequest) -> ConcurrentOperation {
        return ConcurrentOperation { _ in
            dlItem.status = "Queued..."
            
            request.downloadProgress { progress in
                dlItem.status = "Downloading..."
                dlItem.makeStoppable()
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
                            dlItem.status = "Failed! \(response.error!)"
                            if let error = response.error {
                              log.error(error)
                            }

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

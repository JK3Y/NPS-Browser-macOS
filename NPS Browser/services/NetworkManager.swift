//
//  NetworkManager.swift
//  NPS Browser
//
//  Created by JK3Y on 8/10/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Promises
import Alamofire
import SwiftyUserDefaults

class NetworkManager {
    
    let windowDelegate: WindowDelegate = Helpers().getWindowDelegate()
    
    let itemType = Helpers().getWindowDelegate().getItemType()

    func makeRequest() {
        guard let url = Helpers().getUrlSettingsByType(itemType: itemType) else {
            Helpers().makeAlert(messageText: "No URL set for \(self.itemType.console.rawValue) \(self.itemType.fileType.rawValue)s.", informativeText: "Set source paths in the preferences window.", alertStyle: .warning)

            log.error("Invalid URL given for item type: \(itemType.description)")
            return
        }
        
        if (url.isFileURL) {
            guard let isReachable = try? url.checkResourceIsReachable() else {
                Helpers().makeAlert(messageText: "Resource not found!", informativeText: "File does not exist at path: \(url)", alertStyle: .warning)
                return
            }
        }

        let storage = try! RealmStorageContext()
        let ft:FileType = self.windowDelegate.getItemType().fileType
        let ct:ConsoleType = self.windowDelegate.getItemType().console
        
        Promise<[TSVData]> { fulfill, reject in
            Helpers().showLoadingViewController()
            Helpers().getLoadingViewController().setLabel(text: "Requesting data... (step 1/5)")
            Helpers().getLoadingViewController().setProgress(amount: 20)
            
            Alamofire.request(url)
                .downloadProgress { progress in
                    self.windowDelegate.getLoadingViewController().setLabel(text: "Receiving data... (step 2/5)")
                    self.windowDelegate.getLoadingViewController().setProgress(amount: progress.fractionCompleted / 20)
                }
                
                .responseString { response in
                    let utf8Text = String(data: response.data!, encoding: .utf8)
                    
                    if (response.result.isSuccess) {
                        self.windowDelegate.getLoadingViewController().setLabel(text: "Preparing... (step 3/5)")
                        self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                        let parsedTSV = Parser().parseTSV(data: utf8Text!, itemType: self.itemType)
                        fulfill(parsedTSV)
                    }
                    else {
                        reject(response.error!)
                    }
            }
        }
            .then { _ in
                self.windowDelegate.getLoadingViewController().setLabel(text: "Removing old values... (step 4/5)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 50)

                do {
                    try storage.deleteAll(Item.self, predicate: NSPredicate(format: "fileType == %@ AND consoleType == %@", ft.rawValue, ct.rawValue))
                }
        }
            .then { result in
                self.windowDelegate.getLoadingViewController().setLabel(text: "Storing new values... (step 5/5)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                
                do {
                    let objs = result.map { item in
                        return Item(tsvData: item)
                    }
                    DBManager().storeBulk(objArray: objs)
                }
        }
            .then { _ in
                Helpers().getLoadingViewController().closeWindow()
        }
            .then { _ in
                if (self.itemType.console == ConsoleType.PSV && self.itemType.fileType == FileType.Game) {

                    guard let cpackurl = Defaults[.src_compatPacks] else {
                        Helpers().makeAlert(messageText: "No URL set for Compat Packs.", informativeText: "Set source paths in the preferences window.", alertStyle: .warning)
                        
                        log.error("Invalid URL given for compat packs.")
                        return
                    }
                    
                    guard let cpatchurl: URL = Defaults[.src_compatPatch] else {
                        Helpers().makeAlert(messageText: "No URL set for Compat Patches.", informativeText: "Set source paths in the preferences window.", alertStyle: .warning)
                        
                        log.error("Invalid URL given for compat patches")
                        return
                    }
                        
                    if (cpatchurl.isFileURL) {
                        guard (try? cpatchurl.checkResourceIsReachable()) != nil else {
                            Helpers().makeAlert(messageText: "Resource not found!", informativeText: "File does not exist at path: \(cpatchurl)", alertStyle: .warning)
                            return
                        }
                    }

                
                    self.makeCompatPackRequestPromise(url: cpackurl, isPatch: false)
                    .then {_ in
                        self.makeCompatPackRequestPromise(url: cpatchurl, isPatch: true)
                    }
                    
                }
        }
            .then {_ in
                Helpers().getDataController().filterType(itemType: ItemType(console: ct, fileType: ft), region: self.windowDelegate.getRegion())
        }
    }

    func makeCompatPackRequestPromise(url: URL, isPatch: Bool) -> Promise<[CompatPack]?> {
        if url.absoluteString.isEmpty {
            return Promise(nil)
        }
        
        let storage = try! RealmStorageContext()
        
        var typeName: String = "CompatPack"
        if isPatch {
            typeName = "CompatPatch"
        }
        return Promise<[CompatPack]?> { fulfill, reject in
            
          if (self.windowDelegate.getLoadingViewController().presentingViewController != nil) {
                Helpers().showLoadingViewController()
            }
            Helpers().getLoadingViewController().setLabel(text: "Requesting Comp Packs... (step 1/5)")
            Helpers().getLoadingViewController().setProgress(amount: 20)

            Alamofire.request(url)
                .downloadProgress { progress in
                    self.windowDelegate.getLoadingViewController().setLabel(text: "Receiving data... (step 2/5)")
                    self.windowDelegate.getLoadingViewController().setProgress(amount: progress.fractionCompleted / 20)
                }
                .responseString { response in
                    let utf8Text = String(data: response.data!, encoding: .utf8)

                    if (response.result.isSuccess) {
                        self.windowDelegate.getLoadingViewController().setLabel(text: "Preparing... (step 3/5)")
                        self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                        let parsed = Parser().parseCompatPackEntries(data: utf8Text!, isPatch: isPatch, typeName: typeName)
                        fulfill(parsed)
                    }
                    else {
                        reject(response.error!)
                    }
                }
            }
            .then { result in
                self.windowDelegate.getLoadingViewController().setLabel(text: "Removing old values... (step 4/5)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 50)

                do {
                    try storage.deleteAll(CompatPack.self, predicate: NSPredicate(format: "type == %@", typeName))
                }
            }
            .then { result in
                self.windowDelegate.getLoadingViewController().setLabel(text: "Storing new values... (step 5/5)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                DBManager().storeBulk(objArray: result!)
            }
            .then { _ in
                Helpers().getLoadingViewController().closeWindow()
        }
    }

    func getUpdateXMLURLFromHMAC(titleId: String) -> String {
        var output: [String] = []
        var error: [String] = []

        let vitaupdatelinksPath = Bundle.main.path(forResource: "vitaupdatelinks", ofType: nil)
        let task = Process()
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe

        task.launchPath = vitaupdatelinksPath
        task.arguments = [titleId]

        task.launch()

        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }

        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }

        task.waitUntilExit()
        let status = task.terminationStatus

        if (status == 0) {
            debugPrint("Update URL Fetch SUCCESS!")
            return output.first!
        } else {
            return error.first!
        }
    }

    func fetchUpdateXML(url: String) -> (() -> (Promise<URL>)) {

        log.debug(url)

        return {
                Promise<URL> { fulfill, reject in
                Alamofire.request(url)
                    .responseString { response in
                        
                        if let data = response.value {
                            let updateurl = Parser().parseUpdateXML(data: data)
                            if (updateurl != nil) {
                                fulfill(updateurl!)
                            }
                            return

                        } else {
                            reject(response.error!)
                        }
                        
                }
            }
        }

    }
    
}

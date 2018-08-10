//
//  NetworkManager.swift
//  NPS Browser
//
//  Created by JK3Y on 8/10/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Promises
import Alamofire

class NetworkManager {
    
    let windowDelegate: WindowDelegate = Helpers().getWindowDelegate()
    
    var itemType: ItemType?
    
    let settings = SettingsManager().getUrls()
    
    func getURL() -> URL {
        guard let url = try? settings.getByType(itemType: itemType!) else {
            Helpers().makeAlert(messageText: "No URL set for \(self.itemType?.fileType.rawValue)!", informativeText: "Set URL paths in the preferences window.", alertStyle: .warning)
            Helpers().getDataController().setArrayControllerContent(content: nil)
            windowDelegate.stopBtnReloadAnimation()
            
            log.error("Invalid ItemType given: \(itemType?.description)")
        }
        return url!
    }
    
    func makeRequest() {
        itemType = windowDelegate.getItemType()
        let url = getURL()
        
        var storage = try! RealmStorageContext()
        let ft = self.windowDelegate.getItemType().fileType.rawValue
        let ct = self.windowDelegate.getItemType().console.rawValue
        
        Promise<[TSVData]> { fulfill, reject in
            Helpers().showLoadingViewController()
            Helpers().getLoadingViewController().setLabel(text: "Requesting data... (step 1/6)")
            Helpers().getLoadingViewController().setProgress(amount: 20)
            
            Alamofire.request(url)
                .downloadProgress { progress in
                    self.windowDelegate.getLoadingViewController().setLabel(text: "Receiving data... (step 2/6)")
                    self.windowDelegate.getLoadingViewController().setProgress(amount: progress.fractionCompleted / 20)
                }
                
                .responseString { response in
                    let utf8Text = String(data: response.data!, encoding: .utf8)
                    
                    if (response.result.isSuccess) {
                        self.windowDelegate.getLoadingViewController().setLabel(text: "Preparing... (step 3/6)")
                        self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                        let parsedTSV = Parser().parseTSV(data: utf8Text!, itemType: self.itemType!)
                        fulfill(parsedTSV)
                    }
                    else {
                        reject(response.error!)
                    }
            }
        }
            .then { _ in
                self.windowDelegate.getLoadingViewController().setLabel(text: "Removing old values... (step 4/6)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 50)

                do {
                    try storage.deleteAll(Item.self, predicate: NSPredicate(format: "fileType == %@ AND consoleType == %@", ft, ct))
                }
        }
            .then { result in
                self.windowDelegate.getLoadingViewController().setLabel(text: "Storing new values... (step 5/6)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                
                do {
                    let objs = result.map { item in
                        return Item(tsvData: item)
                    }
                    try storage.safeWrite {
                        storage.realm?.add(objs)
                    }
                }
            }
            .then { _ in
                Helpers().getLoadingViewController().closeWindow()
                self.windowDelegate.stopBtnReloadAnimation()
        }
            .then { _ in
                if (self.itemType?.console == ConsoleType.PSV && self.itemType?.fileType == FileType.Game) {
                    self.makeCompatPackRequests()
                }
        }
    }
    
    func makeCompatPackRequests() {
        guard let cpackurl: URL? = SettingsManager().getUrls().compatPacks ?? URL(string: "") else {
            log.debug("no compatpack url")
        }
        guard let cpatchurl: URL? = SettingsManager().getUrls().compatPatch ?? URL(string: "") else {
            log.debug("no compatpatch url")
        }

        makeCompatPackRequestPromise(url: cpackurl!, isPatch: false)
            .then { _ in
                self.makeCompatPackRequestPromise(url: cpatchurl!, isPatch: true)
        }
    }

    func makeCompatPackRequestPromise(url: URL, isPatch: Bool) -> Promise<[CompatPack]> {
        let storage = try! RealmStorageContext()
        
        var typeName: String = "CompatPack"
        if isPatch {
            typeName = "CompatPatch"
        }
        return Promise<[CompatPack]> { fulfill, reject in
            Helpers().showLoadingViewController()
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
                        self.windowDelegate.getLoadingViewController().setLabel(text: "Preparing... (step 3/6)")
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
                do {
                    try storage.safeWrite {
                        storage.realm?.add(result)
                    }
                }
            }
            .then { _ in
                Helpers().getLoadingViewController().closeWindow()
                self.windowDelegate.stopBtnReloadAnimation()
        }
    }

    func getUpdateXMLURLFromHMAC(title_id: String) -> String {
        var output: [String] = []
        var error: [String] = []

        let vitaupdatelinksPath = Bundle.main.resourcePath! + "/vitaupdatelinks"
        let task = Process()
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe

        task.executableURL = URL(fileURLWithPath: vitaupdatelinksPath)
        task.arguments = [title_id]

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

//        return (output, error, status)
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

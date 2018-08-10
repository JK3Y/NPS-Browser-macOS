//
//  NetworkManager.swift
//  NPS Browser
//
//  Created by JK3Y on 5/13/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Promises
import Alamofire
import SWXMLHash
import RealmSwift

class OLDNetworkManager {

    let windowDelegate: WindowDelegate = Helpers().getWindowDelegate()

    var itemType: ItemType?
    
    func makeHTTPRequest() {
        let settings = SettingsManager().getUrls()

        self.itemType = windowDelegate.getItemType()

        guard let url = try? settings.getByType(itemType: itemType!) else {
            Helpers().makeAlert(messageText: "No URL set for \(self.itemType?.fileType.rawValue)!", informativeText: "Set URL paths in the preferences window.", alertStyle: .warning)
            Helpers().getDataController().setArrayControllerContent(content: nil)
            windowDelegate.stopBtnReloadAnimation()
            
            log.error("Invalid FileInfo given: \(itemType?.description)")
            return
        }
        
        Promise<[TSVData]> { fulfill, reject in
            Helpers().showLoadingViewController()
            Helpers().getLoadingViewController().setLabel(text: "Requesting data... (step 1/6)")
            Helpers().getLoadingViewController().setProgress(amount: 20)
            
            Alamofire.request(url!)
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
            .then { result in
                self.windowDelegate.getLoadingViewController().setLabel(text: "Removing old values... (step 4/6)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 50)
                
                var storage = try! RealmStorageContext()
                let ft = self.windowDelegate.getItemType().fileType.rawValue
                let ct = self.windowDelegate.getItemType().console.rawValue

                do {
                    try storage.deleteAll(Item.self, predicate: NSPredicate(format: "fileType == %@ AND consoleType == %@", ft, ct))
                }
                

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
                self.windowDelegate.getLoadingViewController().setLabel(text: "Retrieving values... (step 6/6)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 20)

                let ft = self.windowDelegate.getItemType().fileType.rawValue
                let ct = self.windowDelegate.getItemType().console.rawValue
                let context = try! RealmStorageContext()
                
                var test = context.realm?.objects(Item.self as Object.Type).filter("fileType == %@ AND consoleType == %@", ft, ct)
                
                var items = [Item]()
                
                for item in test! {
                    let tmp = Item.asObject(fromObject: item as! Item)
                    items.append(tmp)
                }
                
                Helpers().getDataController().setArrayControllerContent(content: items)
            }
            .then { _ in
                Helpers().getLoadingViewController().closeWindow()
                self.windowDelegate.stopBtnReloadAnimation()
        }
//            .then { _ in
//                if (self.type == "PSVGames") {
//                    self.makeCompatPackRequests() // get compat packs
//                }
//        }
    }
    
//    func makeCompatPackRequests() {
//        guard var cpackurl: URL? = SettingsManager().getUrls().compatPacks ?? URL(string: "") else {
//            log.debug("no compatpack url")
//        }
//        guard var cpatchurl: URL? = SettingsManager().getUrls().compatPatch ?? URL(string: "") else {
//            log.debug("no compatpatch url")
//        }
//
//        makeCompatPackRequestPromise(url: cpackurl!, isPatch: false)
//            .then { _ in
//                self.makeCompatPackRequestPromise(url: cpatchurl!, isPatch: true)
//        }
//    }
//    
//    func makeCompatPackRequestPromise(url: URL, isPatch: Bool) -> Promise<[CompatPack]> {
//        var typeName: String = "CompatPacks"
//        if isPatch {
//            typeName = "CompatPatch"
//        }
//        return Promise<[CompatPack]> { fulfill, reject in
//            Helpers().showLoadingViewController()
//            Helpers().getLoadingViewController().setLabel(text: "Requesting Comp Packs... (step 1/5)")
//            Helpers().getLoadingViewController().setProgress(amount: 20)
//            
//            Alamofire.request(url)
//                .downloadProgress { progress in
//                    self.windowDelegate.getLoadingViewController().setLabel(text: "Receiving data... (step 2/5)")
//                    self.windowDelegate.getLoadingViewController().setProgress(amount: progress.fractionCompleted / 20)
//                }
//                .responseString { response in
//                    let utf8Text = String(data: response.data!, encoding: .utf8)
//                    
//                    if (response.result.isSuccess) {
//                        self.windowDelegate.getLoadingViewController().setLabel(text: "Preparing... (step 3/6)")
//                        self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
//                        let parsed = Parser().parseCompatPackEntries(data: utf8Text!, isPatch: isPatch)
//                        fulfill(parsed)
//                    }
//                    else {
//                        reject(response.error!)
//                    }
//            }
//            }
//            .then { result in
//                self.windowDelegate.getLoadingViewController().setLabel(text: "Removing old values... (step 4/5)")
//                self.windowDelegate.getLoadingViewController().setProgress(amount: 50)
//                Helpers().getCoreDataIO().deleteCompatPacks(typeName: typeName)
//                
//                self.windowDelegate.getLoadingViewController().setLabel(text: "Storing new values... (step 5/5)")
//                self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
//                Helpers().getCoreDataIO().storeCompatPacks(array: result, isPatch: isPatch)
//            }
//            .then { _ in
//                Helpers().getLoadingViewController().closeWindow()
//                self.windowDelegate.stopBtnReloadAnimation()
//        }
//    }
//    
//    func getUpdateXMLURLFromHMAC(title_id: String) -> String {
//        var output: [String] = []
//        var error: [String] = []
//        
//        let vitaupdatelinksPath = Bundle.main.resourcePath! + "/vitaupdatelinks"
//        let task = Process()
//        let outpipe = Pipe()
//        task.standardOutput = outpipe
//        let errpipe = Pipe()
//        task.standardError = errpipe
//        
//        task.executableURL = URL(fileURLWithPath: vitaupdatelinksPath)
//        task.arguments = [title_id]
//        
//        task.launch()
//        
//        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
//        if var string = String(data: outdata, encoding: .utf8) {
//            string = string.trimmingCharacters(in: .newlines)
//            output = string.components(separatedBy: "\n")
//        }
//        
//        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
//        if var string = String(data: errdata, encoding: .utf8) {
//            string = string.trimmingCharacters(in: .newlines)
//            error = string.components(separatedBy: "\n")
//        }
//        
//        task.waitUntilExit()
//        let status = task.terminationStatus
//        
//        if (status == 0) {
//            debugPrint("Update URL Fetch SUCCESS!")
//            return output.first!
//        } else {
//            return error.first!
//        }
//        
////        return (output, error, status)
//    }
//    
//    func fetchUpdateXML(url: String) -> (() -> (Promise<URL>)) {
//        
//        log.debug(url)
//        
//        return {
//                Promise<URL> { fulfill, reject in
//                Alamofire.request(url)
//                    .responseString { response in
//                        
//                        
//                        if let data = response.value {
//                            let updateurl = Parser().parseUpdateXML(data: data)
//                            if (updateurl != nil) {
//                                fulfill(updateurl!)
//                            }
//                            return
//                            
//                        } else {
//                            reject(response.error!)
//                        }
//                }
//            }
//        }
//
//    }
}

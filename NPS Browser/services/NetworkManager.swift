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

class NetworkManager {

    let windowDelegate: WindowDelegate = Helpers().getWindowDelegate()

    var type: String?
    
    func makeHTTPRequest() {
        let settings = SettingsManager().getUrls()
        
        self.type = windowDelegate.getType()
        let url = settings.getByType(type: self.type!)
        
        if (url == nil) {
            Helpers().makeAlert(messageText: "No URL set for \(self.type!)!", informativeText: "Set URL paths in the preferences window.", alertStyle: .warning)
            Helpers().getDataController().setArrayControllerContent(content: nil)
            windowDelegate.stopBtnReloadAnimation()
            return
        }

        Promise<[NPSBase]> { fulfill, reject in
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
                        let parsedTSV = self.parseTSV(response: utf8Text!)
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
                Helpers().getCoreDataIO().batchDelete(typeName: self.type!)
                
                self.windowDelegate.getLoadingViewController().setLabel(text: "Storing new values... (step 5/6)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                Helpers().getCoreDataIO().storeValues(array: result)
            }
            .then { _ in
                self.windowDelegate.getLoadingViewController().setLabel(text: "Retrieving values... (step 6/6)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                let content = Helpers().getCoreDataIO().getRecords()
                self.windowDelegate.getDataController().setArrayControllerContent(content: content)
        }
            .then { _ in
                Helpers().getLoadingViewController().closeWindow()
                self.windowDelegate.stopBtnReloadAnimation()
        }
            .then { _ in
                if (self.type == "PSVGames" || self.type == "PSVUpdates") {
                    self.getCompatPackEntriesTXT()
                }
        }
    }
    
    func parseTSV(response: String) -> [NPSBase] {
        var parsedData = [NPSBase]()
        var rows = response.split(separator: "\r\n")
        rows.remove(at: 0)
        
        for row in rows {
            let values = row.components(separatedBy: "\t")
            let tsvdata = TSVData(type: type!, values: values)
            parsedData.append(tsvdata.makeNPSObject())
        }
        return parsedData
    }
    
    func parseCompatPackEntries(response: String, isPatch: Bool = false) -> [CompatPack] {
        var parsedData = [CompatPack]()
        let rows = response.split(separator: "\n")
        
        for row in rows {
            
            let baseURL = "https://gitlab.com/nopaystation_repos/nps_compati_packs/raw/master/"
            let components = row.components(separatedBy: "=")
            let path = components.first ?? ""
            var title_id: String
            if (isPatch) {
                title_id = path.components(separatedBy: "/")[1]
            } else {
                title_id = path.components(separatedBy: "/")[0]
            }
            
            let url: URL? = URL(string: "\(baseURL)\(path)")
            let pack = CompatPack(id: title_id, download_url: url!)

            parsedData.append(pack)
        }
        debugPrint(parsedData)
        return parsedData
    }
    
    func getCompatPackEntriesTXT()  {
        var url: URL?
        var isPatch: Bool = false
        var typeName: String = "CompatPacks"
        switch(self.type) {
        case "PSVGames":
            url = SettingsManager().getUrls().compatPacks ?? URL(string: "")
            isPatch = false
            typeName = "CompatPacks"
        case "PSVUpdates":
            url = SettingsManager().getUrls().compatPatch ?? URL(string: "")
            isPatch = true
            typeName = "CompatPatch"
            break
        default:
            url = SettingsManager().getUrls().compatPacks!
        }
        
        if (url == nil) {
            return
        }
        
        Promise<[CompatPack]> { fulfill, reject in
            Helpers().showLoadingViewController()
            Helpers().getLoadingViewController().setLabel(text: "Requesting Comp Packs... (step 1/5)")
            Helpers().getLoadingViewController().setProgress(amount: 20)
            
            Alamofire.request(url!)
                .downloadProgress { progress in
                    self.windowDelegate.getLoadingViewController().setLabel(text: "Receiving data... (step 2/5)")
                    self.windowDelegate.getLoadingViewController().setProgress(amount: progress.fractionCompleted / 20)
                }
                .responseString { response in
                    let utf8Text = String(data: response.data!, encoding: .utf8)
                    
                    if (response.result.isSuccess) {
                        self.windowDelegate.getLoadingViewController().setLabel(text: "Preparing... (step 3/6)")
                        self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                        let parsed = self.parseCompatPackEntries(response: utf8Text!, isPatch: isPatch)
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
            Helpers().getCoreDataIO().deleteCompatPacks(typeName: typeName)
            
            self.windowDelegate.getLoadingViewController().setLabel(text: "Storing new values... (step 5/5)")
            self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
            Helpers().getCoreDataIO().storeCompatPacks(array: result, isPatch: isPatch)
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
    
    func parseUpdateXML(url: String) -> (() -> (Promise<URL>)) {
        
        return {
                Promise<URL> { fulfill, reject in
                Alamofire.request(url)
                    .responseString { response in
                        if let data = response.value {
                            let xml = try! SWXMLHash.parse(data)
                            
                            let subindexer = xml["titlepatch"]["tag"]["package"]
                            
                            for child in subindexer.children {
                                if child.element!.name == "hybrid_package" {
                                    let hp = child.element!.allAttributes
                                    let hpurl = URL(string: (hp["url"]?.text)!)
                                    
                                    fulfill(hpurl!)
                                }
                            }
                        } else {
                            reject(response.error!)
                        }
                }
            }
        }

    }
}

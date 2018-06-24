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

class NetworkManager {

    let windowDelegate: WindowDelegate = Helpers().getWindowDelegate()

    var type: String?
    
    func makeHTTPRequest() {
        let settings = SettingsManager().getUrls()
        self.type = windowDelegate.getType()
        let url = settings.getByType(type: self.type!)
        
        if (url == nil) {
            Helpers().makeAlert(messageText: "No URL set for \(self.type!)!", informativeText: "Set URL paths in the preferences window.", alertStyle: .warning)
            windowDelegate.getDataController().setArrayControllerContent(content: nil)
//            self.windowDelegate.stopBtnReloadAnimation()
            return
        }
        
        Promise<[NPSBase]> { fulfill, reject in
            self.windowDelegate.getDataController().presentViewControllerAsModalWindow(self.windowDelegate.getLoadingViewController())
            self.windowDelegate.getLoadingViewController().setLabel(text: "Requesting data... (step 1/5)")
            self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
            
            Alamofire.request(url!)
                .downloadProgress { progress in
                    self.windowDelegate.getLoadingViewController().setLabel(text: "Receiving data... (step 2/5)")
                    self.windowDelegate.getLoadingViewController().setProgress(amount: progress.fractionCompleted / 20)
                }
                
                .responseString { response in
                    let utf8Text = String(data: response.data!, encoding: .utf8)

                    if (response.result.isSuccess) {
                        self.windowDelegate.getLoadingViewController().setLabel(text: "Preparing... (step 3/5)")
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
//                self.windowDelegate.getLoadingViewController().setLabel(text: "Removing old values... (step 4/6)")
//                self.windowDelegate.getLoadingViewController().setProgress(amount: 50)
                Helpers().getCoreDataIO().batchDelete(type: self.type!)
                
                self.windowDelegate.getLoadingViewController().setLabel(text: "Storing new values... (step 4/5)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                Helpers().getCoreDataIO().storeValues(array: result)
            }
            .then { _ in
                self.windowDelegate.getLoadingViewController().setLabel(text: "Retrieving values... (step 5/5)")
                self.windowDelegate.getLoadingViewController().setProgress(amount: 20)
                let content = Helpers().getCoreDataIO().getRecords()
                self.windowDelegate.getDataController().setArrayControllerContent(content: content)
                self.windowDelegate.getLoadingViewController().closeWindow()
        }
    }
    
    func parseTSV(response: String) -> [NPSBase] {
        var parsedData = [NPSBase]()
        var rows = response.split(separator: "\r\n")
        rows.remove(at: 0)
        
        for row in rows {
            let values = row.components(separatedBy: "\t")
            let tsvdata = TSVData(type: type!, values: values)
            parsedData.append(tsvdata.makeObject())
        }
        return parsedData
    }
}

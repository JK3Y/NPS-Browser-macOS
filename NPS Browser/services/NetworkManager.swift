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
    
    let windowDelegate: WindowDelegate? = NSApplication.shared.mainWindow?.windowController as! WindowController
    
    var type: String?
    
    func makeHTTPRequest() {
        var settings = SettingsManager().getUrls()
        self.type = windowDelegate?.getType()
        let url = settings[type!]
        
        if (url!.isEmpty) {
            Helpers().makeAlert(messageText: "No URL set for \(self.type!)!", informativeText: "Set URL paths in the preferences window.", alertStyle: .warning)

            windowDelegate?.stopBtnReloadAnimation()
            return
        }
        
        Promise<[NPSBase]> { fulfill, reject in
            Alamofire.request(url!)
                .responseString { response in
                    let utf8Text = String(data: response.data!, encoding: .utf8)

                    if (response.result.isSuccess) {
                        fulfill(self.parseTSV(response: utf8Text!))
                    }
                    else {
                        reject(response.error!)
                    }
                }
            }
            .then { result in
                CoreDataIO().batchDelete(type: self.type!)
                CoreDataIO().storeValues(array: result)
                CoreDataIO().updateCacheTimestamp()
            }
            .then { _ in
                let content = CoreDataIO().getRecords()
                self.windowDelegate?.getDataController().setArrayControllerContent(content: content)
        }
    }
    
    func parseTSV(response: String) -> [NPSBase] {
        var parsedData = [NPSBase]()
        var rows = response.split(separator: "\r\n")
        rows.remove(at: 0)
        
        for row in rows {
            let values = row.components(separatedBy: "\t")
            parsedData.append(makeKeyValueArray(values: values))
        }
        return parsedData
    }
    
    func makeKeyValueArray(values: [String]) -> NPSBase {
        var data: [String: String] = [:]
        var obj: NPSBase?
        
        switch(self.type) {
        case "PSVGames":
            data = [
                "title_id"              : values[0],
                "region"                : values[1],
                "name"                  : values[2],
                "pkg_direct_link"       : values[3],
                "zrif"                  : values[4],
                "content_id"            : values[5],
                "last_modification_date": values[6],
                "original_name"         : values[7],
                "file_size"             : values[8],
                "sha256"                : values[9],
                "required_fw"           : values[10]
            ]
            obj = PSVGame(data)
            break
        case "PSVUpdates":
            data = [
                "title_id"              : values[0],
                "region"                : values[1],
                "name"                  : values[2],
                "update_version"        : values[3],
                "fw_version"            : values[4],
                "pkg_direct_link"       : values[5],
                "nonpdrm_mirror"        : values[6],
                "last_modification_date": values[7],
                "file_size"             : values[8],
                "sha256"                : values[9]
            ]
            obj = PSVUpdate(data)
            break
        case "PSVDLCs":
            data = [
                "title_id"              : values[0],
                "region"                : values[1],
                "name"                  : values[2],
                "pkg_direct_link"       : values[3],
                "zrif"                  : values[4],
                "content_id"            : values[5],
                "last_modification_date": values[6],
                "file_size"             : values[7],
                "sha256"                : values[8],
            ]
            obj = PSVDLC(data)
            break
        case "PSXGames":
            data = [
                "title_id"              : values[0],
                "region"                : values[1],
                "name"                  : values[2],
                "pkg_direct_link"       : values[3],
                "content_id"            : values[4],
                "last_modification_date": values[5],
                "original_name"         : values[6],
                "file_size"             : values[7],
                "sha256"                : values[8],
            ]
            obj = PSXGame(data)
            break
        case "PSPGames":
            data = [
                "title_id"              : values[0],
                "region"                : values[1],
                "name"                  : values[3],
                "pkg_direct_link"       : values[4],
                "content_id"            : values[5],
                "last_modification_date": values[6],
                "rap"                   : values[7],
                "download_rap_file"     : values[8],
                "file_size"             : values[9],
                "sha256"                : values[10],
            ]
            obj = PSPGame(data)
            break
        default:
            break
        }
        
        return obj!
    }
}

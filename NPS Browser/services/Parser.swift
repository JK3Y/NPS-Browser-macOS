//
//  Parser.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Fuzi

class Parser {
    func parseTSV(data: String, itemType: ItemType) -> [TSVData] {
        var parsedData: [TSVData] = []
        var rows = data.split(separator: "\r\n")
        rows.remove(at: 0)
        
        for row in rows {
            let values = row.components(separatedBy: "\t")

            let tsvData = TSVData(type: itemType, values: values)
            
            parsedData.append(tsvData)
        }
        return parsedData
    }
    
    func parseCompatPackEntries(data: String, isPatch: Bool = false, typeName: String) -> [CompatPack] {
        var parsedData: [CompatPack] = []
        let rows = data.split(separator: "\n")

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
            
            let pack = CompatPack()
            pack.titleId = title_id
            pack.downloadUrl = "\(baseURL)\(path)"
            pack.type = typeName

            parsedData.append(pack)
        }
        return parsedData
    }

    func parseUpdateXML(data: String) -> URL? {
        let xml = data
        var x: String?
        
        do {
            let document = try XMLDocument(string: xml)
            
            if let root = document.root {
                guard let lastpkg = root.firstChild(tag: "tag")?.children.last else {
                    return nil
                }
                
                var hp = lastpkg.firstChild(tag: "hybrid_package")
                if hp == nil {
                    x = lastpkg.attributes["url"]
                } else {
                    x = hp?.attributes["url"]
                }
            }
        } catch let error {
            log.error(error)
        }
        
        return URL(string: x!)
    }
}

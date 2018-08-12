//
//  Renascene.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class Renascene {
    
    var item: Item
    var consoleType: ConsoleType
    
    init(item: Item) {
        self.item = item
        self.consoleType = ConsoleType(rawValue: item.consoleType!)!
    }
    
    func getUrl(titleId: String) -> URL {
        var url: URL
        switch (consoleType) {
        case .PSV:
            url = URL(string: "http://renascene.com/psv/?target=search&srch=\(titleId)&srchser=1")!
        case .PS3:
            url = URL(string: "http://renascene.com/ps3/?target=search&srch=\(titleId)&srchname=1&srchser=1&srchfold=1&srchfname=1")!
        case .PSP:
            url = URL(string: "http://renascene.com/?target=search1&srch=\(titleId)&srchser=1")!
        case .PSX:
            url = URL(string: "http://renascene.com/ps1/?target=search&srch=\(titleId)&srchser=1")!
        }
        return url
    }
    
    func requestImage() {
        let url = getUrl(titleId: item.titleId!)
        Alamofire.request(url)
            .responseString { response in
//                let html = response
//                
//                if let doc: HTMLDocument = try? HTML(html: html, encoding: .utf8) {
//                    debugPrint(doc.title)
//                }
        }
    }
}

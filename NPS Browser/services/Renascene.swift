//
//  Renascene.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Alamofire
import Promises
import Fuzi

class Renascene {
    
    var item: Item
    var consoleType: ConsoleType
    var searchResultsUrl: String?
    var imageUrl: URL?
    
    init(item: Item) {
        self.item = item
        self.consoleType = ConsoleType(rawValue: item.consoleType!)!
    }
    
    func fetch() -> (() -> (Promise<URL>)) {
        return {
            self.getSearchResultsUrl().then(self.getImageUrl)
        }
    }
    
    func getSearchUrl(titleId: String) -> URL {
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
    
    func getImageUrl(url: String) -> Promise<URL> {
        return Promise<URL> {fulfill, reject in
            Alamofire.request(url)
                .responseString {response in
                    if let string = self.parseRsItem(html: response.data) {
                        let url = URL(string: string)
                        self.imageUrl = url
                        
                        fulfill(url!)
                        return
                    } else {
                        reject(response.error!)
                        
                        log.error(response.error!)
                    }
                }
            }
        
    }
    
    func getSearchResultsUrl() -> Promise<String> {
        return Promise<String> {fulfill, reject in
            let url = self.getSearchUrl(titleId: self.item.titleId!)
            Alamofire.request(url)
                .responseString { response in
                    let html = response.data
                    
                    if let sr = self.parseRsSearchResults(html: html) {
                        self.searchResultsUrl = sr
                        
                        fulfill(sr)
                        return
                    } else {
                        reject(response.error!)
                        
                        log.error(response.error!)
                    }
                }
        }
        
    }
    
    func parseRsSearchResults(html: Data?) -> String? {
        let doc: HTMLDocument
        do {
            doc = try HTMLDocument(data: html!)
            
            if let rsDBUrl = doc.firstChild(css: "td.l > a") {
                return rsDBUrl["href"]!
            }
        } catch let error {
            log.error(error)
        }
        return nil
    }
    
    func parseRsItem(html: Data?) -> String? {
        let doc: HTMLDocument
        do {
            doc = try HTMLDocument(data: html!)

            if let imgUrl = doc.firstChild(css: "td > following-sibling::td[width='300pt'] > img") {
                return imgUrl["src"]!
            }
        } catch let error {
            log.error(error)
        }
        return nil
    }
}

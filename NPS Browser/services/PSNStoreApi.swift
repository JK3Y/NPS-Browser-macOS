//
//  PSNStoreApi.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import Promises

class PSNStoreApi {
    var item: Item
    var consoleType: ConsoleType
    
    init(item: Item) {
        self.item = item
        self.consoleType = ConsoleType(rawValue: item.consoleType!)!
    }
    
    private func getImageURL() -> URL {
        let region = item.region!
        let contentId = item.contentId!
        var language = "en"
        
        var countryAbbv: String = region
        
        switch(region) {
        case "EU": countryAbbv = "GB"
        case "JP":
            language = "ja"
            countryAbbv = "JP"
        case "ASIA": countryAbbv = "SG"
        default: countryAbbv = region
        }
        
        var psnUrl = "https://store.playstation.com/store/api/chihiro/00_09_000/container/\(countryAbbv)/\(language)/19/\(contentId)/1534563384000/image?w=248&h=248"
        return URL(string: psnUrl)!
    }
    
    func getImage() -> Promise<Image> {
        let url = getImageURL()
        return Promise<Image> {fulfill, reject in
            Alamofire.request(url)
                .responseImage { response in
                    if response.result.isSuccess {
                        if let image = response.result.value {
                            fulfill(image)
                        }
                    } else {
                        log.info("No image found for \(self.item.titleId) - \(self.item.name)")
                        fulfill(#imageLiteral(resourceName: "no-image"))
                    }
            }
        }
    }
}

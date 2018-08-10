//
//  NPSModels.swift
//  NPS Browser
//
//  Created by JK3Y on 5/14/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

//import Foundation
//import RealmSwift
//
//protocol NPSItem {
//    var titleId                 : String? {get set}
//    var region                  : String? {get set}
//    var name                    : String? {get set}
//    var pkgDirectLink           : String? {get set}
//    var lastModificationDate    : Date? {get set}
//    var fileSize                : Int64? {get set}
//    var sha256                  : String? {get set}
//    var contentId               : String? {get set}
//    
//    var consoleType             : ConsoleType? {get set}
//    var fileType                : FileType? {get set}
//    
//    func setProps(tsvData: TSVData)
//    func fromTSV(tsvData: TSVData)
//}
//
//class PSV: NPSItem {
//    var titleId: String?
//    var region: String?
//    var name: String?
//    var pkgDirectLink: String?
//    var lastModificationDate: Date?
//    var fileSize: Int64?
//    var sha256: String?
//    var contentId: String?
//    var consoleType: ConsoleType?
//    var fileType: FileType?
//    var zrif                       : String = ""
//    var originalName               : String = ""
//    var requiredFw                 : Float?
//    
//    func setProps(tsvData: TSVData) {
//        titleId = tsvData.titleId
//        region = tsvData.region
//        name = tsvData.name!
//        pkgDirectLink = tsvData.pkgDirectLink
//        lastModificationDate = tsvData.lastModificationDate
//        fileSize = tsvData.fileSize
//        sha256 = tsvData.sha256
//        contentId = tsvData.contentId
//        
//        consoleType = tsvData.consoleType
//        fileType = tsvData.fileType
//    }
//    
//    func fromTSV(tsvData: TSVData) {
//        setProps(tsvData: tsvData)
//        zrif = tsvData.zrif!
//        originalName = tsvData.originalName!
//        requiredFw = tsvData.requiredFw
//    }
//}
//
//class PS3: NPSItem {
//    var titleId: String?
//    var region: String?
//    var name: String?
//    var pkgDirectLink: String?
//    var lastModificationDate: Date?
//    var fileSize: Int64?
//    var sha256: String?
//    var contentId: String?
//    var consoleType: ConsoleType?
//    var fileType: FileType?
//    var rap                         : String?
//    var downloadRapFile             : String?
//    
//    func setProps(tsvData: TSVData) {
//        titleId = tsvData.titleId
//        region = tsvData.region
//        name = tsvData.name!
//        pkgDirectLink = tsvData.pkgDirectLink
//        lastModificationDate = tsvData.lastModificationDate
//        fileSize = tsvData.fileSize
//        sha256 = tsvData.sha256
//        contentId = tsvData.contentId
//        
//        consoleType = tsvData.consoleType
//        fileType = tsvData.fileType
//    }
//    
//    func fromTSV(tsvData: TSVData) {
//        setProps(tsvData: tsvData)
//        rap = tsvData.rap
//        downloadRapFile = tsvData.downloadRapFile
//    }
//}
//
//class PSP: PS3 {}
//
//class CompatPack {
//    var title_id: String
//    var download_url: URL
//    required init(id: String, download_url: URL) {
//        self.title_id     = id
//        self.download_url = download_url
//    }
//}



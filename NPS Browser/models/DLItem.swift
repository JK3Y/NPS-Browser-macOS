//
//  DLItem.swift
//  NPS Browser
//
//  Created by JK3Y on 5/19/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Alamofire

struct DownloadList: Codable {
    var items: [DLItem]
    init(items: [DLItem]) {
        self.items = items
    }
}

enum DownloadType: String {
    case Game, Patch, CPatch, CPack, RAP
}


class DLItem: NSObject, Codable {
    @objc dynamic var title_id          : String?
    @objc dynamic var name              : String?
    @objc dynamic var type              : String?
    @objc dynamic var download_link     : URL?
    @objc dynamic var progress          : Double = 0.0
    @objc dynamic var zrif              : String?
    @objc dynamic var status            : String?
    @objc dynamic var timeRemaining     : TimeInterval = 0
    var request                         : Alamofire.Request?
    var resumeData                      : Data?
    var destination                     : DownloadRequest.DownloadFileDestination?
    @objc dynamic var destinationURL    : URL?
    @objc dynamic var isCancelable      : Bool = false
    @objc dynamic var isViewable        : Bool = false
    @objc dynamic var isRemovable       : Bool = false
    @objc dynamic var isResumable       : Bool = false
    @objc dynamic var download_type     : String?
    @objc dynamic var cpackPath         : URL?
    @objc dynamic var cpatchPath        : URL?
    @objc dynamic var totalFiles        : Int = 0
    @objc dynamic var doneFiles         : Int = 0
    @objc dynamic var doNext            : DLItem? = nil
    @objc dynamic var parentItem        : DLItem? = nil
    
    

    enum CodingKeys: String, CodingKey {
        case title_id
        case name
        case type
        case download_link
        case progress
        case zrif
        case status
        case timeRemaining
        case resumeData
        case destinationURL
        case isCancelable
        case isViewable
        case isRemovable
        case isResumable
        case download_type
        case cpackPath
        case cpatchPath
        case totalFiles
        case doneFiles
        case doNext
        case parentItem
    }
    
    override init() {
//        self.download_type = download_type.rawValue
        super.init()
    }
    
    func isCompleted() -> Bool {
        return doneFiles == totalFiles
    }
    
    func isMore() -> Bool {
        return doNext != nil
    }
    
    func makeCancelable() {
        self.isCancelable   = true
        self.isRemovable    = false
        self.isResumable    = false
        self.isViewable     = false
    }
    
    func makeViewable() {
        self.isViewable     = true
        self.isRemovable    = true
        self.isCancelable   = false
        self.isResumable    = false
    }
    
    func makeResumable() {
        self.isResumable    = true
        self.isRemovable    = true
        self.isCancelable   = false
        self.isViewable     = false
    }
    
    func makeRemovable() {
        self.isRemovable    = true
        self.isResumable    = false
        self.isCancelable   = false
        self.isViewable     = false
    }
    
    func getConsole() -> String {
        return String((type?.prefix(3))!)
    }
}

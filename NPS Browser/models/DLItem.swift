//
//  DLItem.swift
//  NPS Browser
//
//  Created by JK3Y on 5/19/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Alamofire

class DLItem: NSObject {
    @objc dynamic var title_id          : String?
    @objc dynamic var name              : String?
    @objc dynamic var type              : String?
    @objc dynamic var url               : URL?
    @objc dynamic var progress = 0.0
    @objc dynamic var zrif              : String?
    @objc dynamic var status            : String?
    @objc dynamic var timeRemaining     : TimeInterval = 0
    var request: Alamofire.Request?
    @objc dynamic var destinationURL    : URL?
    @objc dynamic var isCancelable      : Bool = true
    @objc dynamic var isViewable        : Bool = false
    @objc dynamic var isRemovable       : Bool = false
    @objc dynamic var isResumable       : Bool = false
    
    override init() {
        super.init()
    }
    
    func setName(_ name: String) {
        self.name = name
    }
    
    func setUrl(_ url: URL) {
        self.url = url
    }
    
    func setZrif(_ zrif: String) {
        self.zrif = zrif
    }
    
    func setRequest(_ request: Alamofire.Request) {
        self.request = request
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
}

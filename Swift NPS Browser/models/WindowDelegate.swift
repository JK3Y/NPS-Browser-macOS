//
//  WindowDelegate.swift
//  Swift NPS Browser
//
//  Created by JK3Y on 5/12/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

protocol WindowDelegate {
    func getType() -> String
    func getRegion() -> String
    
    func startBtnReloadAnimation()
    func stopBtnReloadAnimation()
    
    func addToDownloadQueue(data: DLItem)
    func removeCompletedFromDownloadQueue()
    func getDownloadQueue() -> [DLItem]
    
    func getDataController() -> DataViewController
}

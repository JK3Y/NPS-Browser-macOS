//
//  DownloadListItemCellView.swift
//  NPS Browser
//
//  Created by JK3Y on 5/19/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import SwiftyUserDefaults

class DownloadListItemCellView: NSTableCellView {

    @IBOutlet weak var btnAction: NSButton!
    var item: DLItem?
    var dlLoc = Defaults[.dl_library_folder]

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
        item = objectValue as? DLItem
        
        changeImage()
    }
    
    @IBAction func doAction(_ sender: Any) {
        if (item?.isResumable)! {
            resumeRequest()
        } else if (item?.isStoppable)! {
            stopRequest()
        } else if (item?.isViewable)! {
            viewFile()
        }
    }
    
    func changeImage() {
        if (item?.isResumable)! {
            btnAction.image = #imageLiteral(resourceName: "Start")
        } else if (item?.isStoppable)! {
            btnAction.image = #imageLiteral(resourceName: "Stop")
        } else if (item?.isViewable)! {
            btnAction.image = #imageLiteral(resourceName: "Reveal")
        }
    }
    
    func stopRequest() {
        item!.request?.cancel()
        item!.status = "Stopped"
        item!.makeResumable()
    }
    
    func viewFile() {
        if Defaults[.xt_extract_after_downloading] {
            let ct:ConsoleType = ConsoleType(rawValue: item!.consoleType!)!
            let ft:FileType = FileType(rawValue: item!.fileType!)!
            
            dlLoc?.appendPathComponent(item!.consoleType!)
            
            switch (ct) {
            case .PSV:
                switch(ft) {
                case .Game:
                    dlLoc?.appendPathComponent("app/\(item!.titleId!)")
                case .DLC:
                    dlLoc?.appendPathComponent("addcont/\(item!.titleId!)")
                case .Update:
                    dlLoc?.appendPathComponent("patch/\(item!.titleId!)")
                case .Theme:
                    dlLoc?.appendPathComponent("bgdl/t")
                default: break
                }
            case .PS3:
                NSWorkspace.shared.open(dlLoc!)
            case .PSP:
                dlLoc?.appendPathComponent("pspemu/ISO")
            case .PSX:
                dlLoc?.appendPathComponent("pspemu/")
            }
        }
        
        let str = dlLoc?.absoluteString.removingPercentEncoding
        let path = URL(fileURLWithPath: str!, isDirectory: true)
        
        NSWorkspace.shared.open(path)
    }
    
    func resumeRequest() {
        item!.status = "Resuming..."
        Helpers().getSharedAppDelegate().downloadManager.resumeDownload(data: item!)
        
        item?.makeStoppable()
    }
}

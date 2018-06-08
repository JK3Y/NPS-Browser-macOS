//
//  DetailsController.swift
//  Swift NPS Browser
//
//  Created by JK3Y on 5/6/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DetailsViewController: NSViewController {
    
    @IBOutlet weak var btnDownload: NSButton!

    var windowDelegate: WindowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override var representedObject: Any? {
        didSet {
            self.toggleDownloadButton()
        }
    }

    @IBAction func btnDownloadClicked(_ sender: Any) {
        self.sendDLData()
    }
    
    func toggleDownloadButton() {
        self.windowDelegate = self.view.window!.windowController as! WindowController
        let type = windowDelegate?.getType()
        
        switch(type) {
        case "PSVGames":
            if ((representedObject! as! PSVGameMO).pkg_direct_link?.absoluteString == "MISSING") {
                self.btnDownload.isEnabled = false
            } else {
                self.btnDownload.isEnabled = true
            }
            break
        case "PSVUpdates":
            if ((representedObject! as! PSVUpdateMO).pkg_direct_link?.absoluteString == "MISSING") {
                self.btnDownload.isEnabled = false
            } else {
                self.btnDownload.isEnabled = true
            }
            break
        case "PSVDLCs":
            if ((representedObject! as! PSVDLCMO).pkg_direct_link?.absoluteString == "MISSING") {
                self.btnDownload.isEnabled = false
            } else {
                self.btnDownload.isEnabled = true
            }
            break
        case "PSPGames":
            if ((representedObject! as! PSPGameMO).pkg_direct_link?.absoluteString == "MISSING") {
                self.btnDownload.isEnabled = false
            } else {
                self.btnDownload.isEnabled = true
            }
            break
        case "PSXGames":
            if ((representedObject! as! PSXGameMO).pkg_direct_link?.absoluteString == "MISSING") {
                self.btnDownload.isEnabled = false
            } else {
                self.btnDownload.isEnabled = true
            }
            break
        default:
            break
        }
    }
    
    func sendDLData() {
        self.windowDelegate = self.view.window!.windowController as! WindowController
        
        let type = windowDelegate?.getType()
        
        let obj = DLItem()
        obj.type = type

        switch(type) {
        case "PSVGames":
            obj.title_id = (representedObject! as! PSVGameMO).title_id ?? ""
            obj.name = (representedObject! as! PSVGameMO).name ?? ""
            obj.url = URL(string: ((representedObject! as! PSVGameMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            obj.zrif = (representedObject! as! PSVGameMO).zrif ?? ""
            break
        case "PSVUpdates":
            obj.title_id = (representedObject! as! PSVUpdateMO).title_id ?? ""
            obj.name = (representedObject! as! PSVUpdateMO).name ?? ""
            obj.url = URL(string: ((representedObject! as! PSVUpdateMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            break
        case "PSVDLCs":
            obj.title_id = (representedObject! as! PSVDLCMO).title_id ?? ""
            obj.name = (representedObject! as! PSVDLCMO).name ?? ""
            obj.url = URL(string: ((representedObject! as! PSVDLCMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            obj.zrif = (representedObject! as! PSVDLCMO).zrif ?? ""
            break
        case "PSPGames":
            obj.title_id = (representedObject! as! PSPGameMO).title_id ?? ""
            obj.name = (representedObject! as! PSPGameMO).name ?? ""
            obj.url = URL(string: ((representedObject! as! PSPGameMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            break
        case "PSXGames":
            obj.title_id = (representedObject! as! PSXGameMO).title_id ?? ""
            obj.name = (representedObject! as! PSXGameMO).name ?? ""
            obj.url = URL(string: ((representedObject! as! PSXGameMO).pkg_direct_link?.absoluteString)!) ?? URL(string: "")!
            break
        default:
            break
        }
        
        windowDelegate?.addToDownloadQueue(data: obj)
    }
}

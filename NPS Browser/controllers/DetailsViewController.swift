//
//  DetailsController.swift
//  NPS Browser
//
//  Created by Jacob Amador on 5/6/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DetailsViewController: NSViewController {
    
    @IBOutlet weak var btnDownload: NSButton!
    
    var windowDelegate: WindowDelegate?
    var downloadDelegate: DownloadControllerDelegate?
    
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
        default:
            break
        }
    }
    
    func sendDLData() {
        self.windowDelegate = self.view.window!.windowController as! WindowController

        let type = windowDelegate?.getType()
        var objectDLDetails: [String: Any] = [
            "name": "",
            "url": "",
            "progress": 0,
            "zrif": "",
            ]
        
        switch(type) {
        case "PSVGames":
            objectDLDetails["name"] = (representedObject! as! PSVGameMO).name ?? ""
            objectDLDetails["url"] = (representedObject! as! PSVGameMO).pkg_direct_link?.absoluteString ?? ""
            objectDLDetails["zrif"] = (representedObject! as! PSVGameMO).zrif ?? ""
            break
        case "PSVUpdates":
            objectDLDetails["name"] = (representedObject! as! PSVUpdateMO).name ?? ""
            objectDLDetails["url"] = (representedObject! as! PSVUpdateMO).pkg_direct_link?.absoluteString ?? ""
            break
        case "PSVDLCs":
            objectDLDetails["name"] = (representedObject! as! PSVDLCMO).name ?? ""
            objectDLDetails["url"] = (representedObject! as! PSVDLCMO).pkg_direct_link?.absoluteString ?? ""
            objectDLDetails["zrif"] = (representedObject! as! PSVDLCMO).zrif ?? ""
            break
        default:
            break
        }
        
        downloadDelegate?.addToQueue(data: objectDLDetails)
    }
}

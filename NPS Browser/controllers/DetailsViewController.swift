//
//  DetailsController.swift
//  NPS Browser
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
        let link = ((representedObject as! NSManagedObject).value(forKey: "pkg_direct_link") as! URL?)?.absoluteString
        if (link == "MISSING") {
            self.btnDownload.isEnabled = false
        } else {
            self.btnDownload.isEnabled = true
        }
    }
    
    func sendDLData() {
        let dlitem = Helpers().makeDLItem(data: representedObject as! NSManagedObject)
        Helpers().getSharedAppDelegate().downloadManager.addToDownloadQueue(data: dlitem)
    }
}

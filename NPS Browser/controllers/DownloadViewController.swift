//
//  DownloadViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 5/18/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DownloadViewController: NSViewController {

    @IBOutlet weak var dlTableView: NSTableView!
    @IBOutlet var dlArrayController: NSArrayController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        updateView()
    }
    
    @IBAction func clearCompleted(_ sender: Any) {
        Helpers().getSharedAppDelegate().downloadManager.removeCompleted()
        updateView()
    }
    
    func updateView() {
        let content = Helpers().getSharedAppDelegate().downloadManager.getObjectQueue()
        dlArrayController.content = content
    }
}

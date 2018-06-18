//
//  WindowController.swift
//  NPS Browser
//
//  Created by JK3Y on 5/6/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSToolbarDelegate, WindowDelegate {
    @IBOutlet weak var tbReload: NSButton!
    @IBOutlet weak var progressSpinner: NSProgressIndicator!
    @IBOutlet weak var toolbar: NSToolbar!
    @IBOutlet weak var tbType: NSPopUpButton!
    @IBOutlet weak var tbRegion: NSPopUpButton!
    @IBOutlet weak var tbSearchBar: NSSearchField!
    var delegate: ToolbarDelegate?

    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func onTypeChanged(_ sender: Any) {
        startBtnReloadAnimation()
        self.delegate = getDataController()

        if (Helpers().getCoreDataIO().recordsAreEmpty()) {
            NetworkManager().makeHTTPRequest()
        } else {
            let content = Helpers().getCoreDataIO().getRecords()
            delegate?.setArrayControllerContent(content: content)
        }
    }
    
    @IBAction func onRegionChanged(_ sender: Any) {
        startBtnReloadAnimation()
        self.delegate = getDataController()
        let content = CoreDataIO().getRecords()
        delegate?.setArrayControllerContent(content: content)
    }

    @IBAction func btnReloadClicked(_ sender: Any) {
        startBtnReloadAnimation()
        NetworkManager().makeHTTPRequest()
    }
    
    @IBAction func onFilterSearchBar(_ sender: NSSearchField) {
        self.delegate = getDataController()
        let searchString = tbSearchBar.stringValue
        
        if (searchString.isEmpty) {
            let content = CoreDataIO().getRecords()
            delegate?.setArrayControllerContent(content: content)
        } else {
            let content = CoreDataIO().searchRecords(searchString: searchString)
            delegate?.setArrayControllerContent(content: content)
        }
    }
    
    func getDataController() -> DataViewController {
        let splitViewController = self.window!.contentViewController! as! NSSplitViewController
        let vc: DataViewController = splitViewController.splitViewItems[0].viewController as! DataViewController
        return vc
    }

    func getType() -> String {
        let type = tbType.selectedItem?.title.replacingOccurrences(of: " ", with: "")
        return type!
    }
    
    func getRegion() -> String {
        let region = tbRegion.selectedItem?.title
        return region!
    }
    
    func startBtnReloadAnimation() {
        self.tbReload.isHidden = true
        self.progressSpinner.usesThreadedAnimation = true
        self.progressSpinner.startAnimation(nil)
    }
    
    func stopBtnReloadAnimation() {
        self.progressSpinner.stopAnimation(nil)
        self.tbReload.isHidden = false
    }
}

//
//  WindowController.swift
//  NPS Browser
//
//  Created by Jacob Amador on 5/6/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import ProgressKit

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

        if (CoreDataIO().recordsAreEmpty()) {
            NetworkManager().makeHTTPRequest()
        } else {
            let content = CoreDataIO().getRecords()
            delegate?.setArrayControllerContent(content: content)
        }
        stopBtnReloadAnimation()
    }
    
    @IBAction func onRegionChanged(_ sender: Any) {
        startBtnReloadAnimation()
        self.delegate = getDataController()
        let content = CoreDataIO().getRecords()
        delegate?.setArrayControllerContent(content: content)
    }

    @IBAction func btnReloadClicked(_ sender: Any) {
        print("REFRESH CLICKED")
        
        startBtnReloadAnimation()
        
        NetworkManager().makeHTTPRequest()
        
        // delay spinner stop animation
//        let when = DispatchTime.now() + 0.5
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            self.stopBtnReloadAnimation()
//        }
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

//
//  WindowController.swift
//  NPS Browser
//
//  Created by JK3Y on 5/6/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import RealmSwift

class WindowController: NSWindowController, NSToolbarDelegate, WindowDelegate {
    @IBOutlet weak var tbReload: NSButton!
    @IBOutlet weak var progressSpinner: NSProgressIndicator!
    @IBOutlet weak var toolbar: NSToolbar!
    @IBOutlet weak var tbType: NSPopUpButton!
    @IBOutlet weak var tbRegion: NSPopUpButton!
    @IBOutlet weak var tbSearchBar: NSSearchField!
    var delegate: ToolbarDelegate?
    var loadingViewController: LoadingViewController?

    override func windowDidLoad() {
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        super.windowDidLoad()
        let vc: LoadingViewController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "loadingVC")) as! LoadingViewController
        loadingViewController = vc
        
        self.delegate = getDataController()
    }
    
    @IBAction func onTypeChanged(_ sender: Any) {
        delegate?.filterType(itemType: getItemType(), region: getRegion())
    }
    
    @IBAction func onRegionChanged(_ sender: Any) {
        delegate?.filterType(itemType: getItemType(), region: getRegion())
    }

    @IBAction func btnReloadClicked(_ sender: Any) {
        startBtnReloadAnimation()
        NetworkManager().makeRequest()
    }
    
    @IBAction func onFilterSearchBar(_ sender: NSSearchField) {
        let searchString = tbSearchBar.stringValue
        
        if (!searchString.isEmpty) {
            delegate?.filterString(itemType: getItemType(), region: getRegion(), searchString: searchString)
        } else {
            delegate?.filterType(itemType: getItemType(), region: getRegion())
        }
    }
    
    func getDataController() -> DataViewController {
        let splitViewController = self.window!.contentViewController! as! NSSplitViewController
        let vc: DataViewController = splitViewController.splitViewItems[0].viewController as! DataViewController
        return vc
    }
    
    func getLoadingViewController() -> LoadingViewController {
        return loadingViewController!
    }

    func getItemType() -> ItemType {
        return ItemType.parseString((tbType.selectedItem?.title)!)
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

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
      let vc: LoadingViewController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("loadingVC")) as! LoadingViewController
        loadingViewController = vc
        
        self.delegate = getDataController()
    }
    
    @IBAction func onTypeChanged(_ sender: Any) {
        delegate?.filterType(itemType: getItemType(), region: getRegion())
    }
    
    @IBAction func onRegionChanged(_ sender: Any) {
        delegate?.filterType(itemType: getItemType(), region: getRegion())
    }

    @IBAction func onFilterSearchBar(_ sender: NSSearchField) {
        let searchString = tbSearchBar.stringValue
        
        if (!searchString.isEmpty) {
            delegate?.filterString(itemType: getItemType(), region: getRegion(), searchString: searchString)
        } else {
            delegate?.filterType(itemType: getItemType(), region: getRegion())
        }
    }
    
    @IBAction func reloadDatabase(_ sender: NSMenuItem) {
        NetworkManager().makeRequest()
    }

//    @IBAction func toggleArtworkSidebar(_ sender: NSMenuItem) {
//        debugPrint(sender)
//
//        let sv = getDataController().getDetailsViewController().getBoxartViewController().parent as! NSSplitViewController
//        let av = sv.splitViewItems.last!
//
//        if av.isCollapsed {
//            av.isCollapsed = false
//
//            sender.title = "Hide Artwork"
//        } else {
//            av.isCollapsed = true
//            sender.title = "Show Artwork"
//        }
//        // TODO: use nextResponder to pass toggleSidebar call to Artwork Controller
////        Respon
//    }
    
    
    func getDataController() -> DataViewController {
        let splitViewController = self.window!.contentViewController! as! NSSplitViewController
        let vc: DataViewController = splitViewController.splitViewItems[0].viewController as! DataViewController
        return vc
    }
    
    func getLoadingViewController() -> LoadingViewController {
        return loadingViewController!
    }

    func getItemType() -> ItemType {
//        return
        return ItemType.parseString((tbType.selectedItem?.title)!, ItemType.getTypeFromTag(tbType.selectedItem?.tag ?? 0))
    }
    
    func getRegion() -> String {
        let tag = tbRegion.selectedItem?.tag
        switch (tag) {
        case 0:
            return "US"
        case 1:
            return "EU"
        case 2:
            return "JP"
        case 3:
            return "ASIA"
        default:
            return "US"
        }
        
//        return region!
    }
    
}

import Foundation
class SplitViewController: NSSplitViewController {
    
    override func toggleSidebar(_ sender: Any?) {
        let mi = sender as! NSMenuItem
        debugPrint(mi.title)

        for view in splitViewItems {
            if view.canCollapse {
                if view.isCollapsed {
                    view.isCollapsed = false
                    mi.title = "Hide Sidebar"
                } else  {
                    view.isCollapsed = true
                    mi.title = "Show Sidebar"
                }
            }
        }
    }
    
}

//class MenuItemController: NSMenuItem {
//    func fds() {
//        self.get
//    }
//    
////    override func menuWillOpen(_ menu: NSMenu) {
//////        menu.su
////    }
//}

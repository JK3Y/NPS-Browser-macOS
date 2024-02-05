//
//  DataViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import RealmSwift
import SwiftyUserDefaults

class DataViewController: NSViewController, ToolbarDelegate {
    
    @IBOutlet var tsvResultsController: NSArrayController!
    @IBOutlet weak var tableView: NSTableView!
    lazy var windowDelegate: WindowDelegate = Helpers().getWindowDelegate()

    var notificationToken: NotificationToken?
    
    private var realm: Realm = {
        return DBMigration.configureMigration()
    }()
    
    var items: Results<Item>? = try! Realm().objects(Item.self)
    
    override func viewDidAppear() {
        let it = windowDelegate.getItemType()
        let ct = it.console.rawValue
        let ft = it.fileType.rawValue
        let reg = windowDelegate.getRegion()

        if (items?.isEmpty)! {
            NetworkManager().makeRequest()
        } else {
            setArrayControllerContent(content: items?.filter(NSPredicate(format: "consoleType == %@ AND fileType == %@ AND region == %@ AND pkgDirectLink != 'MISSING'", ct, ft, reg)))
        }
    }

    override var representedObject: Any? {
        didSet {
            self.getDetailsViewController().representedObject = representedObject
        }
    }

    @IBAction func tableSelectionChanged(_ sender: NSTableView) {
        if (!tsvResultsController.selectedObjects.isEmpty) {
            self.representedObject = tsvResultsController.selectedObjects.first
        }
    }
    
    func makePredicateString() -> String {
        var str = "consoleType == %@ AND fileType == %@ AND region == %@ "
        let it = windowDelegate.getItemType()
        
        if Defaults[.dsp_hide_invalid_url_items] {
            str.append(" AND pkgDirectLink != 'MISSING'")
            
            switch( it.console ) {
            case .PSV:
                str.append(" AND zrif != 'MISSING'")
            default: break
            }
        }
        return str
    }
    
    func filterType(itemType: ItemType, region: String) {
        let p = NSPredicate(format: makePredicateString(), itemType.console.rawValue, itemType.fileType.rawValue, region)
        let objects = items!.filter(p)
        
        if objects.isEmpty {
            NetworkManager().makeRequest()
        }
        setArrayControllerContent(content: objects)
    }
    
    func filterString(itemType: ItemType, region: String, searchString: String) {
//        let p = NSPredicate(format: "consoleType == %@ AND fileType == %@ AND region == %@ AND name contains[c] %@ AND pkgDirectLink != 'MISSING'", itemType.console.rawValue, itemType.fileType.rawValue, region, searchString)
        var p = makePredicateString()
        p.append(" AND name contains[c] %@")
        var q = NSPredicate(format: p, itemType.console.rawValue, itemType.fileType.rawValue, region, searchString)

        let objects = items!.filter(q) ?? nil
        setArrayControllerContent(content: objects)
    }
    
    func setArrayControllerContent(content: Results<Item>?) {
        tsvResultsController.content = Array(content!)
        tsvResultsController.setSelectionIndex(0)
        tableSelectionChanged(tableView)
    }
    
    func getDetailsViewController() -> DetailsViewController {
      let sc: NSSplitViewController = parent?.children[1] as! NSSplitViewController
      let vc: DetailsViewController = sc.children[0] as! DetailsViewController
        return vc
    }
}

//
//  DataViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import RealmSwift

class DataViewController: NSViewController, ToolbarDelegate {
    
    @IBOutlet var tsvResultsController: NSArrayController!
    @IBOutlet weak var tableView: NSTableView!
    lazy var windowDelegate: WindowDelegate = Helpers().getWindowDelegate()

    var notificationToken: NotificationToken?
    
    private var realm: Realm = {
        return try! Realm()
    }()
    
    var items: Results<Item>?
    
    override func viewWillAppear() {
        
        // TODO: Check if realm is empty, if it is run network manager
        
        super.viewDidLoad()
        // Do view setup here.
        let it = self.windowDelegate.getItemType()
        let ct = it.console.rawValue
        let ft = it.fileType.rawValue
        let reg = self.windowDelegate.getRegion()

        items = try! Realm().objects(Item.self)
        
        setArrayControllerContent(content: Array(items!.filter(NSPredicate(format: "consoleType == %@ AND fileType == %@ AND region == %@ AND pkgDirectLink != 'MISSING'", ct, ft, reg))))
    }
    
    override var representedObject: Any? {
        didSet {
//         Update the view, if already loaded.
            self.getDetailsViewController().representedObject = representedObject
        }
    }

    @IBAction func tableSelectionChanged(_ sender: NSTableView) {
        if (!tsvResultsController.selectedObjects.isEmpty) {
            self.representedObject = tsvResultsController.selectedObjects.first
        }
    }
    
    
    func filterByRegion(region: String) {
        let p = NSPredicate(format: "region == %@", region)
        setArrayControllerContent(content: Array( items!.filter(p) ))
    }
    
    func filterType(itemType: ItemType) {}
    
    func setArrayControllerContent(content: [Item]?) {
        tsvResultsController.content = nil
        tsvResultsController.content = content
        tsvResultsController.setSelectionIndex(0)
        tableSelectionChanged(tableView)
    }
    
    func getDetailsViewController() -> DetailsViewController {
        let sc: NSSplitViewController = parent?.childViewControllers[1] as! NSSplitViewController
        let vc: DetailsViewController = sc.childViewControllers[0] as! DetailsViewController
        return vc
    }
    
//    func getBoxartViewController() {
//        let sc: NSSplitViewController = parent?.childViewControllers[1] as! NSSplitViewController
//        let vc: DetailsViewController = sc.childViewControllers[1] as! DetailsViewController
//        return vc
//    }
}

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

    private var notificationToken: NotificationToken?
    
    private var realm: Realm = {
        return try! Realm()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        notificationToken = realm.objects(Item.self).observe { change in
            let it = self.windowDelegate.getItemType()
            let ct = it.console.rawValue
            let ft = it.fileType.rawValue
            let reg = self.windowDelegate.getRegion()
            
            switch change {
            case .initial(let objects):
                self.setArrayControllerContent(content: Array(objects.filter("consoleType == %@ AND fileType == %@ AND region == %@ AND pkgDirectLink != 'MISSING'", ct, ft, reg)))
            case .update(let objects, _, _, _):
                self.setArrayControllerContent(content: Array(objects.filter("consoleType == %@ AND fileType == %@ AND region == %@ AND pkgDirectLink != 'MISSING'", ct, ft, reg)))
            case .error(let error):
                log.error(error)
            }
        }
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

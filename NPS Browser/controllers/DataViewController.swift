//
//  ViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DataViewController: NSViewController, ToolbarDelegate {
    
    @IBOutlet var tsvResultsController: NSArrayController!
    @IBOutlet weak var tableView: NSTableView!
    lazy var windowDelegate: WindowDelegate = Helpers().getWindowDelegate()
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            self.getDetailsViewController().representedObject = representedObject
        }
    }

    @IBAction func tableSelectionChanged(_ sender: NSTableView) {
        if (!tsvResultsController.selectedObjects.isEmpty) {
            self.representedObject = tsvResultsController.selectedObjects.first
        }
    }
    
    func setArrayControllerContent(content: [NSManagedObject]?) {
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
}

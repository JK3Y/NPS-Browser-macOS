//
//  ViewController.swift
//  Swift NPS Browser
//
//  Created by JK3Y on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class DataViewController: NSViewController, ToolbarDelegate {
    
    @IBOutlet var tsvResultsController: NSArrayController!
    @IBOutlet weak var tableView: NSTableView!
    var windowDelegate: WindowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    override func viewDidAppear() {
        self.windowDelegate = NSApplication.shared.mainWindow?.windowController as! WindowController
        
        windowDelegate?.startBtnReloadAnimation()
        if (CoreDataIO().recordsAreEmpty()) {
            NetworkManager().makeHTTPRequest()
        } else {
            let content = CoreDataIO().getRecords()
            tsvResultsController.content = content
        }
        windowDelegate?.stopBtnReloadAnimation()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            let vc: DetailsViewController = parent?.childViewControllers[1] as! DetailsViewController
            vc.representedObject = representedObject
        }
    }

    @IBAction func tableSelectionChanged(_ sender: NSTableView) {
        if (!tsvResultsController.selectedObjects.isEmpty) {
            self.representedObject = tsvResultsController.selectedObjects.first
        }
    }

    func getTypeFromToolbar() -> String? {
        return windowDelegate?.getType()
    }
    
    func getRegionFromToolbar() -> String? {
        return windowDelegate?.getRegion()
    }
    
    func setArrayControllerContent(content: [NSManagedObject]?) {
        tsvResultsController.content = nil
        tsvResultsController.content = content
        
        windowDelegate?.stopBtnReloadAnimation()
    }
}

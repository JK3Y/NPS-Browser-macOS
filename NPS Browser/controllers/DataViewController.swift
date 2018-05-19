//
//  ViewController.swift
//  NPS Browser
//
//  Created by Jacob Amador on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Alamofire
import Promises
import CoreData

class DataViewController: NSViewController, ToolbarDelegate {
    
    @IBOutlet var tsvResultsController: NSArrayController!
    @IBOutlet weak var tableView: NSTableView!
    var delegate: WindowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    override func viewDidAppear() {
        self.delegate = getWindowController()
        if (CoreDataIO().recordsAreEmpty()) {
            NetworkManager().makeHTTPRequest()
        } else {
            let content = CoreDataIO().getRecords()
            tsvResultsController.content = content
        }
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
            self.representedObject = tsvResultsController.selectedObjects[0]
        }
    }

    func getTypeFromToolbar() -> String? {
        self.delegate = getWindowController()
        return delegate!.getType()
    }
    
    func getRegionFromToolbar() -> String? {
        self.delegate = getWindowController()
        return delegate!.getRegion()
    }
    
    func getWindowController() -> WindowController {
        let window = self.view.window!.windowController as! WindowController
        return window
    }
    
    func setArrayControllerContent(content: [NSManagedObject]?) {
        tsvResultsController.content = nil
        tsvResultsController.content = content

        delegate?.stopBtnReloadAnimation()
    }
}

//
//  LoadingViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 6/23/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class LoadingViewController: NSViewController, LoadingViewDelegate {
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var txtStatus: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear() {
        progressIndicator.doubleValue = 0.0
        setLabel(text: "")
    }
    
    func setLabel(text: String) {
        self.txtStatus.stringValue = text
    }
    
    func setProgress(amount: Double) {
        self.progressIndicator.increment(by: amount)
    }
    
    func closeWindow() {
        if (self.presentingViewController != nil) {
            dismiss(self)
        } else {
            return
        }
    }
}

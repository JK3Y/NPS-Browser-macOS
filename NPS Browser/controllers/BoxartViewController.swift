//
//  BoxartViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class BoxartViewController: NSViewController {
    @IBOutlet weak var imgBoxart: NSImageView!
    
    override var representedObject: Any? {
        didSet {
            getImage()
        }
    }
    
    func setImage(url: URL) {
        
    }
    
    func getImage() {
        Renascene(item: representedObject as! Item).requestImage()
    }
}

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
        let i = NSImage(contentsOf: url)
        self.imgBoxart.sizeToFit()
        self.imgBoxart.image = i
    }
    
    func getImage() {
        let rs = Renascene(item: representedObject as! Item)
        let f = rs.fetch()
        
        f().then { url in

            self.setImage(url: url)

        }
    }
}

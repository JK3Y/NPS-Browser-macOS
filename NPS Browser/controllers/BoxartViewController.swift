//
//  BoxartViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class BoxartViewController: NSViewController, GameArtworkDelegate {
    @IBOutlet weak var imgBoxart: NSImageView!
    
    override var representedObject: Any? {
        didSet {
            imgBoxart.image = nil
            
            getImage()
        }
    }
    
    func setImage(image: NSImage) {
        self.imgBoxart.sizeToFit()
        self.imgBoxart.image = image
    }
    
    func getImage() {
        let rs = Renascene(item: representedObject as! Item)
        let f = rs.fetch()
        
        f().then { url in
            if let i = NSImage(contentsOf: url) {
                self.setImage(image: i)
            } else {
                self.noImage()
            }
        }
    }
    
    func noImage() {
        let img = #imageLiteral(resourceName: "no-image")
        setImage(image: img)
    }
}

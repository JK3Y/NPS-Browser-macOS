//
//  GameArtworkViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 8/3/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class GameArtworkViewController: NSViewController {
    @IBOutlet weak var imgBoxart: NSImageView!

    override var representedObject: Any? {
        didSet {
            imgBoxart.image = nil
            
            getImage()
        }
    }
    
    private func setImage(image: NSImage) {
//        self.imgBoxart.sizeToFit()
        self.imgBoxart.image = image
    }
    
    func getImage() {
        PSNStoreApi(item: representedObject as! Item).getImage()
            .then { image in
                self.setImage(image: image)
        }
    }
}

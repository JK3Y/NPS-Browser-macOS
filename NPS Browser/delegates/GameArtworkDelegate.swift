//
//  GameArtworkDelegate.swift
//  NPS Browser
//
//  Created by JK3Y on 8/12/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//
import Foundation
import Cocoa

protocol GameArtworkDelegate {
    func setImage(image: NSImage)
    
    func noImage()
}

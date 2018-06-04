//
//  Settings.swift
//  NPS Browser
//
//  Created by Jacob Amador on 5/20/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation

struct Settings: Codable {
    var urls: [String: String]
    var downloads: [String: URL]
    var extract: [String: Bool]
    var compressionFactor: Int
    
    init(){
        self.urls = [
        "PSVGames": "",
        "PSVUpdates": "",
        "PSVDLCs": "",
        "PSXGames": "",
        "PSPGames": "",
        ]
        self.downloads = [
            "download_location": FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads")
        ]
        self.extract = [
            "extract_after_downloading": true,
            "keep_pkg": false,
            "save_as_zip": false,
            "create_license": true,
            "compress_psp_iso": false,
        ]
        self.compressionFactor = 1
    }
    
    init(urls: [String: String], downloads: [String: URL], extract: [String: Bool], compressionFactor: Int) {
        self.urls = urls
        self.downloads = downloads
        self.extract = extract
        self.compressionFactor = compressionFactor
    }
}

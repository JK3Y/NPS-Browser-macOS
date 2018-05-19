//
//  NPSModels.swift
//  NPS Browser
//
//  Created by Jacob Amador on 4/29/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class Settings: NSObject {
    struct defaultSettings {
        var urls: [String: String] = [
            "PSVGames": "",
            "PSVUpdates": "",
            "PSVDLCs": "",
            "PSXGames": "",
            "PSPGames": "",
            ]
        var downloads: [String: String] = [
            "download_location": NSHomeDirectory()
        ]
        var extract: [String: Bool] = [
            "extract_after_downloading": true,
            "keep_pkg": false,
            "save_as_zip": false,
            "create_license": true
        ]
        func getUrls() -> [String: String] {
            return self.urls
        }
        func getDownloads() -> [String: String] {
            return self.downloads
        }
        func getExtract() -> [String: Bool] {
            return self.extract
        }
        func getDefaultArray() -> [String: Any] {
            return [
                "urls": urls,
                "downloads": downloads,
                "extract": extract,
            ]
        }
        func printDefaults() {
            print("urls: \(self.urls) \n downloads: \(self.downloads) \n extract: \(self.extract)")
        }
    }
}

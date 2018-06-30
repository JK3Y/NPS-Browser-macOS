//
//  Settings.swift
//  NPS Browser
//
//  Created by JK3Y on 5/20/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation

struct Settings: Codable {
    var source  : SourceSettings
    var download: DownloadSettings
    var extract : ExtractSettings
    var display : DisplaySettings
    init(){
        self.source     = SourceSettings.init()
        self.download   = DownloadSettings.init()
        self.extract    = ExtractSettings.init()
        self.display    = DisplaySettings.init()
    }
    init(source: SourceSettings, download: DownloadSettings, extract: ExtractSettings, display: DisplaySettings) {
        self.source     = source
        self.download   = download
        self.extract    = extract
        self.display    = display
    }
}

struct SourceSettings: Codable {
    var psv_games   : URL?
    var psv_dlc     : URL?
    var psv_updates : URL?
    var psv_themes  : URL?
    var psp_games   : URL?
    var psx_games   : URL?
    var ps3_games   : URL?
    var ps3_dlc     : URL?
    var ps3_themes  : URL?
    var ps3_avatars : URL?
    init(){
        self.psv_games      = URL(string: "")
        self.psv_dlc        = URL(string: "")
        self.psv_updates    = URL(string: "")
        self.psv_themes     = URL(string: "")
        self.psp_games      = URL(string: "")
        self.psx_games      = URL(string: "")
        self.ps3_games      = URL(string: "")
        self.ps3_dlc        = URL(string: "")
        self.ps3_themes     = URL(string: "")
        self.ps3_avatars    = URL(string: "")
    }
    init(psv_games: String, psv_dlc: String, psv_updates: String, psv_themes: String, psp_games: String, psx_games: String, ps3_games: String, ps3_dlc: String, ps3_themes: String, ps3_avatars: String) {
        self.psv_games      = URL(string: psv_games) ?? URL(string: "")
        self.psv_dlc        = URL(string: psv_dlc) ?? URL(string: "")
        self.psv_updates    = URL(string: psv_updates) ?? URL(string: "")
        self.psv_themes     = URL(string: psv_themes) ?? URL(string: "")
        self.psp_games      = URL(string: psp_games) ?? URL(string: "")
        self.psx_games      = URL(string: psx_games) ?? URL(string: "")
        self.ps3_games      = URL(string: ps3_games) ?? URL(string: "")
        self.ps3_dlc        = URL(string: ps3_dlc) ?? URL(string: "")
        self.ps3_themes     = URL(string: ps3_themes) ?? URL(string: "")
        self.ps3_avatars    = URL(string: ps3_avatars) ?? URL(string: "")
    }
    func getByType(type: String) -> URL? {
        switch type {
        case "PSVGames":
            return self.psv_games
        case "PSVDLCs":
            return self.psv_dlc
        case "PSVUpdates":
            return self.psv_updates
        case "PSVThemes":
            return self.psv_themes
        case "PSPGames":
            return self.psp_games
        case "PSXGames":
            return self.psx_games
        case "PS3Games":
            return self.ps3_games
        case "PS3DLCs":
            return self.ps3_dlc
        case "PS3Themes":
            return self.ps3_themes
        case "PS3Avatars":
            return self.ps3_avatars
        default:
            break
        }
        return nil
    }
}

struct DownloadSettings: Codable {
    var download_location   : URL
    var concurrent_downloads: Int
    init(){
        self.download_location      = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads")
        self.concurrent_downloads   = 3
    }
    init(download_location: URL, concurrent_downloads: Int) {
        self.download_location      = download_location
        self.concurrent_downloads   = concurrent_downloads
    }
}

struct ExtractSettings: Codable {
    var extract_after_downloading   : Bool
    var keep_pkg                    : Bool
    var save_as_zip                 : Bool
    var create_license              : Bool
    var compress_psp_iso            : Bool
    var compression_factor          : Int
    var unpack_ps3_packages         : Bool
    init(){
        self.extract_after_downloading  = true
        self.keep_pkg                   = false
        self.save_as_zip                = false
        self.create_license             = true
        self.compress_psp_iso           = false
        self.compression_factor         = 1
        self.unpack_ps3_packages        = false
    }
    init(extract_after_downloading: Bool, keep_pkg: Bool, save_as_zip: Bool, create_license: Bool, compress_psp_iso: Bool, compression_factor: Int){
        self.extract_after_downloading  = extract_after_downloading
        self.keep_pkg                   = keep_pkg
        self.save_as_zip                = save_as_zip
        self.create_license             = create_license
        self.compress_psp_iso           = compress_psp_iso
        self.compression_factor         = compression_factor
        self.unpack_ps3_packages        = false
    }
}

struct DisplaySettings: Codable {
    var hide_invalid_url_items: Bool
    init() {
        self.hide_invalid_url_items = false
    }
    init(hide_invalid_url_items: Bool) {
        self.hide_invalid_url_items = hide_invalid_url_items
    }
}

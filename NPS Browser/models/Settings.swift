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
    var update  : UpdateSettings
    init(){
        self.source     = SourceSettings()
        self.download   = DownloadSettings()
        self.extract    = ExtractSettings()
        self.display    = DisplaySettings()
        self.update     = UpdateSettings()
    }
    init(source: SourceSettings, download: DownloadSettings, extract: ExtractSettings, display: DisplaySettings, update: UpdateSettings) {
        self.source     = source
        self.download   = download
        self.extract    = extract
        self.display    = display
        self.update     = update
    }
}

struct SourceSettings: Codable {
    var psv_games   : URL?
    var psv_dlc     : URL?
    var psv_themes  : URL?
    var psp_games   : URL?
    var psx_games   : URL?
    var ps3_games   : URL?
    var ps3_dlc     : URL?
    var ps3_themes  : URL?
    var ps3_avatars : URL?
    var compatPacks : URL?
    var compatPatch : URL?
    init(){
        self.psv_games      = URL(string: "")
        self.psv_dlc        = URL(string: "")
        self.psv_themes     = URL(string: "")
        self.psp_games      = URL(string: "")
        self.psx_games      = URL(string: "")
        self.ps3_games      = URL(string: "")
        self.ps3_dlc        = URL(string: "")
        self.ps3_themes     = URL(string: "")
        self.ps3_avatars    = URL(string: "")
        self.compatPacks    = URL(string: "")
        self.compatPatch    = URL(string: "")
    }
    init(psv_games: String, psv_dlc: String, psv_themes: String, psp_games: String, psx_games: String, ps3_games: String, ps3_dlc: String, ps3_themes: String, ps3_avatars: String, compat_pack: String, compat_patch: String) {
        self.psv_games      = URL(string: psv_games) ?? URL(string: "")
        self.psv_dlc        = URL(string: psv_dlc) ?? URL(string: "")
        self.psv_themes     = URL(string: psv_themes) ?? URL(string: "")
        self.psp_games      = URL(string: psp_games) ?? URL(string: "")
        self.psx_games      = URL(string: psx_games) ?? URL(string: "")
        self.ps3_games      = URL(string: ps3_games) ?? URL(string: "")
        self.ps3_dlc        = URL(string: ps3_dlc) ?? URL(string: "")
        self.ps3_themes     = URL(string: ps3_themes) ?? URL(string: "")
        self.ps3_avatars    = URL(string: ps3_avatars) ?? URL(string: "")
        self.compatPacks    = URL(string: compat_pack) ?? URL(string: "")
        self.compatPatch    = URL(string: compat_patch) ?? URL(string: "")
    }
    func getByType(itemType: ItemType) -> URL? {
        switch (itemType.console) {
        case .PSV:
            switch (itemType.fileType) {
            case .Game: return psv_games
            case .DLC: return psv_dlc
            case .Theme: return psv_themes
            case .CPack: return compatPacks
            case .CPatch: return compatPatch
            default: break
            }
        case .PS3:
            switch (itemType.fileType) {
            case .Game: return ps3_games
            case .DLC: return ps3_dlc
            case .Theme: return ps3_themes
            case .Avatar: return ps3_avatars
            default: break
            }
        case .PSP: return psp_games
        case .PSX: return psx_games
        }
        
        return nil
    }
}

struct DownloadSettings: Codable {
    var library_location   : URL
    var concurrent_downloads: Int
    var library_folder: URL
    
    init(){
        self.library_location      = try! NSHomeDirectory().asURL().appendingPathComponent("Downloads")
        self.concurrent_downloads   = 3
        self.library_folder = library_location.appendingPathComponent("NPS Downloads", isDirectory: true)
    }
    init(library_location: URL, concurrent_downloads: Int) {
        self.library_location      = library_location
        self.concurrent_downloads   = concurrent_downloads
        self.library_folder = library_location.appendingPathComponent("NPS Downloads", isDirectory: true)
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

struct UpdateSettings: Codable {
    var automatically_check: Bool
    var last_checked: Date?
    init() {
        self.automatically_check = true
        self.last_checked = nil
    }
    init(automatically_check: Bool, last_checked: Date?) {
        self.automatically_check = automatically_check
        self.last_checked = last_checked
    }
}

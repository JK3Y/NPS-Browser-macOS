//
//  DefaultsKeys.swift
//  NPS Browser
//
//  Created by JK3Y on 8/17/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//
import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let src_psv_games   = DefaultsKey<URL?>("src_psv_games", defaultValue: URL(string:"http://nopaystation.com/tsv/PSV_GAMES.tsv")!)
    static let src_psv_dlcs    = DefaultsKey<URL?>("src_psv_dlcs", defaultValue: URL(string:"http://nopaystation.com/tsv/PSV_DLCS.tsv")!)
    static let src_psv_themes  = DefaultsKey<URL?>("src_psv_themes", defaultValue: URL(string:"http://nopaystation.com/tsv/PSV_THEMES.tsv")!)
    static let src_psp_games   = DefaultsKey<URL?>("src_psp_games", defaultValue: URL(string:"http://nopaystation.com/tsv/PSP_GAMES.tsv")!)
    static let src_psx_games   = DefaultsKey<URL?>("src_psx_games", defaultValue: URL(string:"http://nopaystation.com/tsv/PSX_GAMES.tsv")!)
    static let src_ps3_games   = DefaultsKey<URL?>("src_ps3_games", defaultValue: URL(string:"http://nopaystation.com/tsv/PS3_GAMES.tsv")!)
    static let src_ps3_dlcs    = DefaultsKey<URL?>("src_ps3_dlcs", defaultValue: URL(string:"http://nopaystation.com/tsv/PS3_DLCS.tsv")!)
    static let src_ps3_themes  = DefaultsKey<URL?>("src_ps3_themes", defaultValue: URL(string:"http://nopaystation.com/tsv/PS3_THEMES.tsv")!)
    static let src_ps3_avatars = DefaultsKey<URL?>("src_ps3_avatars", defaultValue: URL(string:"http://nopaystation.com/tsv/PS3_AVATARS.tsv")!)
    static let src_compatPacks = DefaultsKey<URL?>("src_compatPacks", defaultValue: URL(string:"https://gitlab.com/nopaystation_repos/nps_compati_packs/raw/master/entries.txt")!)
    static let src_compatPatch = DefaultsKey<URL?>("src_compatPatch", defaultValue: URL(string:"https://gitlab.com/nopaystation_repos/nps_compati_packs/raw/master/entries_patch.txt")!)
    
    static let dl_library_location        = DefaultsKey<URL?>("dl_library_location", defaultValue: try! NSHomeDirectory().asURL().appendingPathComponent("Downloads"))
    static let dl_library_folder          = DefaultsKey<URL?>("dl_library_folder", defaultValue: try! NSHomeDirectory().asURL().appendingPathComponent("Downloads").appendingPathComponent("NPS Downloads", isDirectory: true))
    static let dl_concurrent_downloads    = DefaultsKey<Int>("dl_concurrent_downloads", defaultValue: 3)

    static let xt_library_location        = DefaultsKey<URL?>("xt_library_location", defaultValue: try! NSHomeDirectory().asURL().appendingPathComponent("Downloads"))
    static let xt_library_folder          = DefaultsKey<URL?>("xt_library_folder", defaultValue: try! NSHomeDirectory().asURL().appendingPathComponent("Downloads").appendingPathComponent("NPS Downloads", isDirectory: true))

    static let xt_extract_after_downloading   = DefaultsKey<Bool>("xt_extract_after_downloading", defaultValue: true)
    static let xt_keep_pkg                    = DefaultsKey<Bool>("xt_keep_pkg", defaultValue: false)
    static let xt_save_as_zip                 = DefaultsKey<Bool>("xt_save_as_zip", defaultValue: false)
    static let xt_create_license              = DefaultsKey<Bool>("xt_create_license", defaultValue: true)
    static let xt_compress_psp_iso            = DefaultsKey<Bool>("xt_compress_psp_iso", defaultValue: false)
    static let xt_compression_factor          = DefaultsKey<Int>("xt_compression_factor", defaultValue: 1)
    static let xt_unpack_ps3_packages         = DefaultsKey<Bool>("xt_unpack_ps3_packages", defaultValue: false)
    
    static let dsp_hide_invalid_url_items = DefaultsKey<Bool>("dsp_hide_invalid_url_items", defaultValue: true)
}

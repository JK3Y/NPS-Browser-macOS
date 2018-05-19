//
//  Settings.swift
//  NPS Browser
//
//  Created by Jacob Amador on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Foundation

class SettingsViewController: NSViewController {
    @IBOutlet weak var psvgField: NSTextField!
    @IBOutlet weak var psvuField: NSTextField!
    @IBOutlet weak var psvdlcField: NSTextField!
    @IBOutlet weak var psxgField: NSTextField!
    @IBOutlet weak var pspgField: NSTextField!
    @IBOutlet weak var dlPathField: NSTextField!
    @IBOutlet weak var chkExtractPKG: NSButton!
    @IBOutlet weak var chkCreateLicense: NSButton!
    @IBOutlet weak var chkKeepPKG: NSButton!
    @IBOutlet weak var chkSaveZip: NSButton!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settings = getSettings()
        updateTextFields(settings: settings)
    }
    
    func updateTextFields(settings: [String: Any]) {
        let urls = settings["urls"]             as! [String: String]
        let downloads = settings["downloads"]   as! [String: String]
        let extract = settings["extract"]       as! [String: Bool]
//        let cache = settings["cache"]           as! [String: Int]

        psvgField.stringValue   = urls["PSVGames"]!
        psvuField.stringValue   = urls["PSVUpdates"]!
        psvdlcField.stringValue = urls["PSVDLCs"]!
        psxgField.stringValue   = urls["PSXGames"]!
        pspgField.stringValue   = urls["PSPGames"]!
        
        dlPathField.stringValue = downloads["download_location"]!
        
        chkExtractPKG.state     = extract["extract_after_downloading"]! ? .on : .off
        chkKeepPKG.state        = extract["keep_pkg"]! ? .on : .off
        chkSaveZip.state        = extract["save_as_zip"]! ? .on : .off
        chkCreateLicense.state  = extract["create_license"]! ? .on : .off
    }
    
    func getSettings() -> [String: Any] {
        return defaults.object(forKey: "settings") as? [String: Any] ?? Settings.defaultSettings().getDefaultArray()
    }
    
    func setSettings(settings: [String: Any]) {
        defaults.set(settings, forKey: "settings")
    }

    @IBAction func save(_ sender: Any) {
        let settings = [
            "urls": [
                "PSVGames"                  : psvgField.stringValue,
                "PSVUpdates"                : psvuField.stringValue,
                "PSVDLCs"                   : psvdlcField.stringValue,
                "PSXGames"                  : psxgField.stringValue,
                "PSPGames"                  : pspgField.stringValue
            ],
            "downloads": [
                "download_location"         : dlPathField.stringValue
            ],
            "extract": [
                "extract_after_downloading" : chkExtractPKG.state == .on,
                "keep_pkg"                  : chkKeepPKG.state == .on,
                "save_as_zip"               : chkSaveZip.state == .on,
                "create_license"            : chkCreateLicense.state == .on
            ]
        ]
        setSettings(settings: settings)
        dismissViewController(self)
    }
    
    func clearUserDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}

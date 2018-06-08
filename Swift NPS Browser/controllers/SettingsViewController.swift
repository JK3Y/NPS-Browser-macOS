//
//  Settings.swift
//  Swift NPS Browser
//
//  Created by JK3Y on 4/28/18.
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
    @IBOutlet weak var chkCompressPSPISO: NSButton!
    @IBOutlet weak var compressionFactorStepper: NSStepper!
    @IBOutlet weak var compressionFactorField: NSTextField!
    
    var dlLocation: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settings = SettingsManager().getSettings()
        updateTextFields(settings: settings!)
    }
    
    @IBAction func toggleCompressionFactor(_ sender: NSButton) {
        switch sender.state {
        case .on:
            compressionFactorStepper.isEnabled = true
            compressionFactorField.isEnabled = true
            break
        case .off :
            compressionFactorStepper.isEnabled = false
            compressionFactorField.isEnabled = false
            break
        default:
            break
        }
    }
    
    @IBAction func stepCompressionFactor(_ sender: Any) {
        compressionFactorField.integerValue = compressionFactorStepper.integerValue
    }
    
    func updateTextFields(settings: Settings) {
        let urls = settings.urls
        let downloads = settings.downloads
        let extract = settings.extract
        
        self.dlLocation = downloads["download_location"]!
        
        psvgField.stringValue   = urls["PSVGames"]!
        psvuField.stringValue   = urls["PSVUpdates"]!
        psvdlcField.stringValue = urls["PSVDLCs"]!
        psxgField.stringValue   = urls["PSXGames"]!
        pspgField.stringValue   = urls["PSPGames"]!
        
        dlPathField.stringValue = self.dlLocation!.path

        chkExtractPKG.state     = extract["extract_after_downloading"]! ? .on : .off
        chkKeepPKG.state        = extract["keep_pkg"]! ? .on : .off
        chkSaveZip.state        = extract["save_as_zip"]! ? .on : .off
        chkCreateLicense.state  = extract["create_license"]! ? .on : .off
        chkCompressPSPISO.state = extract["compress_psp_iso"]! ? .on : .off
        
        compressionFactorField.integerValue = settings.compressionFactor
        compressionFactorStepper.integerValue = settings.compressionFactor
    }
    
    @IBAction func selectDLPath(_ sender: Any) {
        guard let window = view.window else { return }
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        panel.beginSheetModal(for: window) { (result) in
            if result == NSApplication.ModalResponse.OK {
                self.dlLocation = panel.urls[0]
                self.dlPathField.stringValue = self.dlLocation!.path
            }
        }
    }
    
    @IBAction func resetToDefaults(_ sender: Any) {
        updateTextFields(settings: SettingsManager().getDefaultSettings())
    }
    
    @IBAction func save(_ sender: Any) {
        let urls = [
            "PSVGames"                  : psvgField.stringValue,
            "PSVUpdates"                : psvuField.stringValue,
            "PSVDLCs"                   : psvdlcField.stringValue,
            "PSXGames"                  : psxgField.stringValue,
            "PSPGames"                  : pspgField.stringValue
        ]
        let downloads = [
            "download_location"         : self.dlLocation!.absoluteURL
        ]
        let extract = [
            "extract_after_downloading" : chkExtractPKG.state == .on,
            "keep_pkg"                  : chkKeepPKG.state == .on,
            "save_as_zip"               : chkSaveZip.state == .on,
            "create_license"            : chkCreateLicense.state == .on,
            "compress_psp_iso"          : chkCompressPSPISO.state == .on
        ]
        let compressionFactor = compressionFactorField.integerValue

        let settings = Settings(urls: urls, downloads: downloads, extract: extract, compressionFactor: compressionFactor)
        SettingsManager().setSettings(settings: settings)
        dismissViewController(self)
    }
}

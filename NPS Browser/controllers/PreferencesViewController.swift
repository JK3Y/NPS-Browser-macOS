//
//  SettingsViewController.swift
//  NPS Browser
//
//  Created by JK3Y on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Foundation
import SwiftyUserDefaults

class PreferencesViewController: NSViewController {
    // Sources
    @IBOutlet weak var psvgField: NSTextField!
    @IBOutlet weak var psvdlcField: NSTextField!
    @IBOutlet weak var psvtField: NSTextField!
    @IBOutlet weak var psxgField: NSTextField!
    @IBOutlet weak var pspgField: NSTextField!
    @IBOutlet weak var ps3gField: NSTextField!
    @IBOutlet weak var ps3dlcField: NSTextField!
    @IBOutlet weak var ps3tField: NSTextField!
    @IBOutlet weak var ps3aField: NSTextField!
    @IBOutlet weak var compatPackField: NSTextField!
    @IBOutlet weak var compatPatchField: NSTextField!
    
    // Display
    @IBOutlet weak var chkHideInvalidURLItems: NSButton!
    
    // Downloads
    @IBOutlet weak var ccDLField: NSTextField!
    @IBOutlet weak var dlPathField: NSTextField!
    
    // Extraction Methods
    @IBOutlet weak var chkExtractPKG: NSButton!
    @IBOutlet weak var chkCreateLicense: NSButton!
    @IBOutlet weak var chkKeepPKG: NSButton!
    @IBOutlet weak var chkSaveZip: NSButton!
    @IBOutlet weak var chkCompressPSPISO: NSButton!
    @IBOutlet weak var compressionFactorStepper: NSStepper!
    @IBOutlet weak var compressionFactorField: NSTextField!
//    @IBOutlet weak var chkUnpackPS3Packages: NSButton!
    
    // Updates
    @IBOutlet weak var chkAutomaticallyCheck: NSButton!
    @IBOutlet weak var btnCheckUpdatesNow: NSButton!
    @IBOutlet weak var lblUpdateLastChecked: NSTextField!
    
    
//    let settings = SettingsManager().getSettings()
    var dlLocation: URL?
    var update_checked: Date? = nil
    
    override func viewWillAppear() {
        // Remove fullscreen and ability to resize the window
        self.view.window?.styleMask.remove(.fullScreen)
        self.view.window?.styleMask.remove(.resizable)
    }

    override func viewDidLoad() {
        updateTextFields()
        super.viewDidLoad()
    }
    
    @IBAction func toggleEnableExtractionSettings(_ sender: Any) {
        switch chkExtractPKG.state {
        case .off:
            chkCreateLicense.isEnabled = false
            chkKeepPKG.isEnabled = false
            chkSaveZip.isEnabled = false
            chkCompressPSPISO.isEnabled = false
        case .on:
            chkCreateLicense.isEnabled = true
            chkKeepPKG.isEnabled = true
            chkSaveZip.isEnabled = true
            chkCompressPSPISO.isEnabled = true
        default:
            break
        }
    }
    
    
    @IBAction func toggleCompressionFactor(_ sender: Any) {
        switch chkCompressPSPISO.state {
        case .on:
            compressionFactorStepper.isEnabled = true
            compressionFactorField.isEnabled = true
        case .off :
            compressionFactorStepper.isEnabled = false
            compressionFactorField.isEnabled = false
        default:
            break
        }
    }
    
    @IBAction func stepCompressionFactor(_ sender: Any) {
        compressionFactorField.integerValue = compressionFactorStepper.integerValue
    }
    
    func updateTextFields() {
        self.dlLocation = Defaults[.dl_library_location]

        psvgField.stringValue                   = Defaults[.src_psv_games]?.absoluteString ?? ""
        psvdlcField.stringValue                 = Defaults[.src_psv_dlcs]?.absoluteString ?? ""
        psvtField.stringValue                   = Defaults[.src_psv_themes]?.absoluteString ?? ""
        psxgField.stringValue                   = Defaults[.src_psx_games]?.absoluteString ?? ""
        pspgField.stringValue                   = Defaults[.src_psp_games]?.absoluteString ?? ""
        ps3gField.stringValue                   = Defaults[.src_ps3_games]?.absoluteString ?? ""
        ps3dlcField.stringValue                 = Defaults[.src_ps3_dlcs]?.absoluteString ?? ""
        ps3tField.stringValue                   = Defaults[.src_ps3_themes]?.absoluteString ?? ""
        ps3aField.stringValue                   = Defaults[.src_ps3_avatars]?.absoluteString ?? ""
        compatPackField.stringValue             = Defaults[.src_compatPacks]?.absoluteString ?? ""
        compatPatchField.stringValue            = Defaults[.src_compatPatch]?.absoluteString ?? ""

        chkHideInvalidURLItems.state            = Defaults[.dsp_hide_invalid_url_items] ? .on : .off
        ccDLField.integerValue                  = Defaults[.dl_concurrent_downloads]
        dlPathField.stringValue                 = self.dlLocation!.path

        chkExtractPKG.state                     = Defaults[.xt_extract_after_downloading] ? .on : .off
        chkKeepPKG.state                        = Defaults[.xt_keep_pkg] ? .on : .off
        chkSaveZip.state                        = Defaults[.xt_save_as_zip] ? .on : .off
        chkCreateLicense.state                  = Defaults[.xt_create_license] ? .on : .off
        chkCompressPSPISO.state                 = Defaults[.xt_compress_psp_iso] ? .on : .off
        
        compressionFactorField.integerValue     = Defaults[.xt_compression_factor]
        compressionFactorStepper.integerValue   = Defaults[.xt_compression_factor]
        
        chkAutomaticallyCheck.state             = Defaults[.upd_automatically_check] ? .on : .off
        lblUpdateLastChecked.stringValue        = Helpers().relativePast(for: Defaults[.upd_last_checked])
        
        toggleEnableExtractionSettings(self)
        toggleCompressionFactor(self)
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
    
    @IBAction func chooseTSVFile(_ sender: NSButton) {
        let id = sender.identifier!.rawValue
        
        func openDialog(txtField: NSTextField) {
            guard let window = view.window else { return }
            let panel = NSOpenPanel()
            panel.canChooseFiles = true
            panel.canChooseDirectories = false
            panel.allowsMultipleSelection = false
            panel.beginSheetModal(for: window) { (result) in
                if result == NSApplication.ModalResponse.OK {
                    txtField.stringValue = panel.url!.absoluteString
                }
            }
        }
        
        switch(id) {
        case "psvg": openDialog(txtField: self.psvgField)
        case "psvd": openDialog(txtField: self.psvdlcField)
        case "psvt": openDialog(txtField: self.psvtField)
        case "psxg": openDialog(txtField: self.psxgField)
        case "pspg": openDialog(txtField: self.pspgField)
        case "ps3g": openDialog(txtField: self.ps3gField)
        case "ps3d": openDialog(txtField: self.ps3dlcField)
        case "ps3t": openDialog(txtField: self.ps3tField)
        case "ps3a": openDialog(txtField: self.ps3aField)
        case "compatpack": openDialog(txtField: self.compatPackField)
        case "compatpatch": openDialog(txtField: self.compatPatchField)
        default: break
        }
    }
    
    @IBAction func checkUpdateApp(_ sender: NSButton) {
        AppUpdateChecker().fetchLatest() { (ghVersion, browserDownloadURL) in
            // Get current date
            let date = Date()
            self.update_checked = date
            self.lblUpdateLastChecked.stringValue = Helpers().relativePast(for: date)

            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                let downloadUrl: URL = URL(string: browserDownloadURL)!
                
                debugPrint(appVersion, ghVersion, browserDownloadURL)
                
                if appVersion < ghVersion {
                    let alert = NSAlert()
                    alert.messageText = "Update Available"
                    alert.informativeText = "A new version is available!"
                    alert.alertStyle = .informational
                    alert.addButton(withTitle: "Download")
                    alert.addButton(withTitle: "Cancel")
                    let responseTag = alert.runModal()
                    
                    if responseTag.rawValue == 1000 {
                        self.save(self)
                        AppUpdateChecker().downloadUpdate(url: downloadUrl)
                        log.info("Downloading update")
                    }
                }
            }
        }
    }

    @IBAction func resetToDefaults(_ sender: Any) {
        Defaults.removeAll()
    }
    
    @IBAction func save(_ sender: Any) {
        storePreferences()
    }
    
    func validateAndStore(urlString: String, endsWith: String, defaultsKey: DefaultsKey<URL?>) throws {
        if urlString.isEmpty {
            Defaults.set(URL(string:""), forKey: defaultsKey._key)
            return
        }

        let url = URL(string: urlString)

        if url?.pathExtension == endsWith {
            Defaults[defaultsKey] = url
        } else {
            Helpers().makeAlert(messageText: "Invalid URL", informativeText: "Invalid URL given: \(urlString). File must have extension '.\(endsWith)'", alertStyle: .critical)
            throw NSError()
        }
    }
    
    func storePreferences() {
        do {
            try validateAndStore(urlString: psvgField.stringValue, endsWith: "tsv", defaultsKey: .src_psv_games)
            try validateAndStore(urlString: psvdlcField.stringValue, endsWith: "tsv", defaultsKey: .src_psv_dlcs)
            try validateAndStore(urlString: psvtField.stringValue, endsWith: "tsv", defaultsKey: .src_psv_themes)
            try validateAndStore(urlString: psxgField.stringValue, endsWith: "tsv", defaultsKey: .src_psx_games)
            try validateAndStore(urlString: pspgField.stringValue, endsWith: "tsv", defaultsKey: .src_psp_games)
            try validateAndStore(urlString: ps3gField.stringValue, endsWith: "tsv", defaultsKey: .src_ps3_games)
            try validateAndStore(urlString: ps3dlcField.stringValue, endsWith: "tsv", defaultsKey: .src_ps3_dlcs)
            try validateAndStore(urlString: ps3tField.stringValue, endsWith: "tsv", defaultsKey: .src_ps3_themes)
            try validateAndStore(urlString: ps3aField.stringValue, endsWith: "tsv", defaultsKey: .src_ps3_avatars)
            try validateAndStore(urlString: compatPackField.stringValue, endsWith: "txt", defaultsKey: .src_compatPacks)
            try validateAndStore(urlString: compatPatchField.stringValue, endsWith: "txt", defaultsKey: .src_compatPatch)

            Defaults[.dl_library_location]      = self.dlLocation!.absoluteURL
            Defaults[.dl_concurrent_downloads]  = ccDLField.integerValue
            
            Defaults[.xt_extract_after_downloading] = chkExtractPKG.state == .on
            Defaults[.xt_keep_pkg]                  = chkKeepPKG.state == .on
            Defaults[.xt_save_as_zip]               = chkSaveZip.state == .on
            Defaults[.xt_create_license]            = chkCreateLicense.state == .on
            Defaults[.xt_compress_psp_iso]          = chkCompressPSPISO.state == .on
            Defaults[.xt_compression_factor]        = compressionFactorField.integerValue
            
            Defaults[.dsp_hide_invalid_url_items]   = chkHideInvalidURLItems.state == .on
            
            Defaults[.upd_automatically_check]      = chkAutomaticallyCheck.state == .on
            Defaults[.upd_last_checked]             = update_checked

            
            dismissViewController(self)
        } catch {
            return
        }
    }
}

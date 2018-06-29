//
//  Settings.swift
//  NPS Browser
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
    @IBOutlet weak var psvtField: NSTextField!
    @IBOutlet weak var psxgField: NSTextField!
    @IBOutlet weak var pspgField: NSTextField!
    
    @IBOutlet weak var chkHideInvalidURLItems: NSButton!
    
    @IBOutlet weak var ccDLField: NSTextField!
    @IBOutlet weak var dlPathField: NSTextField!
    
    @IBOutlet weak var chkExtractPKG: NSButton!
    @IBOutlet weak var chkCreateLicense: NSButton!
    @IBOutlet weak var chkKeepPKG: NSButton!
    @IBOutlet weak var chkSaveZip: NSButton!
    @IBOutlet weak var chkCompressPSPISO: NSButton!
    @IBOutlet weak var compressionFactorStepper: NSStepper!
    @IBOutlet weak var compressionFactorField: NSTextField!
    
    let settings = SettingsManager().getSettings()
    var dlLocation: URL?
    
    override func viewWillAppear() {
        // Remove fullscreen and ability to resize the window
        self.view.window?.styleMask.remove(.fullScreen)
        self.view.window?.styleMask.remove(.resizable)
    }

    override func viewDidLoad() {
        updateTextFields(settings: settings!)
        super.viewDidLoad()
    }
    
    @IBAction func toggleEnableExtractionSettings(_ sender: Any) {
        switch chkExtractPKG.state {
        case .off:
            chkCreateLicense.isEnabled = false
            chkKeepPKG.isEnabled = false
            chkSaveZip.isEnabled = false
            chkCompressPSPISO.isEnabled = false
            break
        case .on:
            chkCreateLicense.isEnabled = true
            chkKeepPKG.isEnabled = true
            chkSaveZip.isEnabled = true
            chkCompressPSPISO.isEnabled = true
            break
        default:
            break
        }
    }
    
    
    @IBAction func toggleCompressionFactor(_ sender: Any) {
        switch chkCompressPSPISO.state {
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
        self.dlLocation = settings.download.download_location

        psvgField.stringValue                   = settings.source.psv_games?.absoluteString ?? ""
        psvuField.stringValue                   = settings.source.psv_updates?.absoluteString ?? ""
        psvdlcField.stringValue                 = settings.source.psv_dlc?.absoluteString ?? ""
        psvtField.stringValue                   = settings.source.psv_themes?.absoluteString ?? ""
        psxgField.stringValue                   = settings.source.psx_games?.absoluteString ?? ""
        pspgField.stringValue                   = settings.source.psp_games?.absoluteString ?? ""

        chkHideInvalidURLItems.state            = settings.display.hide_invalid_url_items ? .on : .off

        ccDLField.integerValue                  = settings.download.concurrent_downloads
        dlPathField.stringValue                 = self.dlLocation!.path

        chkExtractPKG.state                     = settings.extract.extract_after_downloading ? .on : .off
        chkKeepPKG.state                        = settings.extract.keep_pkg ? .on : .off
        chkSaveZip.state                        = settings.extract.save_as_zip ? .on : .off
        chkCreateLicense.state                  = settings.extract.create_license ? .on : .off
        chkCompressPSPISO.state                 = settings.extract.compress_psp_iso ? .on : .off

        compressionFactorField.integerValue     = settings.extract.compression_factor
        compressionFactorStepper.integerValue   = settings.extract.compression_factor
        
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
    
    @IBAction func resetToDefaults(_ sender: Any) {
        updateTextFields(settings: SettingsManager().getDefaultSettings())
    }
    
    @IBAction func save(_ sender: Any) {
        let source      = SourceSettings(psv_games: psvgField.stringValue,
                                         psv_dlc: psvdlcField.stringValue,
                                         psv_updates: psvuField.stringValue,
                                         psv_themes: psvtField.stringValue,
                                         psp_games: pspgField.stringValue,
                                         psx_games: psxgField.stringValue)
        let download    = DownloadSettings(download_location: self.dlLocation!.absoluteURL,
                                           concurrent_downloads: ccDLField.integerValue)
        let extract     = ExtractSettings(extract_after_downloading: chkExtractPKG.state == .on,
                                          keep_pkg: chkKeepPKG.state == .on,
                                          save_as_zip: chkSaveZip.state == .on,
                                          create_license: chkCreateLicense.state == .on,
                                          compress_psp_iso: chkCompressPSPISO.state == .on,
                                          compression_factor: compressionFactorField.integerValue)
        let display     = DisplaySettings(hide_invalid_url_items: chkHideInvalidURLItems.state == .on)
        let settings = Settings(source: source, download: download, extract: extract, display: display)
        SettingsManager().setSettings(settings: settings)
        
        dismissViewController(self)
    }
}

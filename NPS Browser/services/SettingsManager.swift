//
//  SettingsManager.swift
//  NPS Browser
//
//  Created by JK3Y on 4/29/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa

class SettingsManager {
    
    let defaults = UserDefaults.standard

    init() {}
    
    func getSettings() -> Settings? {
        let stored = defaults.object(forKey: "settings") as? Data
        
        if (stored == nil) {
            resetUserDefaults(self)
            return Settings()
        } else {
            do {
                let settings = try PropertyListDecoder().decode(Settings.self, from: stored!)
                return settings
            } catch let error as NSError {
                resetUserDefaults(self)
                
                Helpers().makeAlert(messageText: "Error loading settings.", informativeText: "Loading defaults now...", alertStyle: .warning)
                log.error("Error loading user DefaultSettings.")
            }
        }
        
        return Settings()
    }
    
    func getUrls() -> SourceSettings {
        return (getSettings()?.source)!
    }
    
    func getDownloads() -> DownloadSettings {
        return (getSettings()?.download)!
    }
    
    func getExtract() -> ExtractSettings {
        return (getSettings()?.extract)!
    }
    
    func getDisplay() -> DisplaySettings {
        return (getSettings()?.display)!
    }
    
    func getUpdate() -> UpdateSettings {
        return (getSettings()?.update)!
    }
    
    func getUserDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func setSettings(settings: Settings) {
        do {
            let data = try PropertyListEncoder().encode(settings)
            getUserDefaults().set(data, forKey: "settings")
        } catch {
            Helpers().makeAlert(messageText: "Save failed", informativeText: "Settings could not be saved.", alertStyle: .warning)
            log.error("Settings could not be saved.")
        }
    }
    
    func getDefaultSettings() -> Settings {
        return Settings()
    }
    
    @IBAction func resetUserDefaults(_ sender: Any) {
        let defaults = Settings()
        setSettings(settings: defaults)
    }

    func clearUserDefaults() {
        getUserDefaults().removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}

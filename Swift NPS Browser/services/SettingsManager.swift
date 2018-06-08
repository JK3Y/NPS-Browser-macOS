//
//  SettingsManager.swift
//  Swift NPS Browser
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
        } else {
            do {
                let settings = try PropertyListDecoder().decode(Settings.self, from: stored!)
                return settings
            } catch let error as NSError {
                debugPrint(error)
                
                Helpers().makeAlert(messageText: "Error loading settings.", informativeText: "Loading defaults now...", alertStyle: .warning)
            }
        }
        
        return Settings()
    }
    
    func getUrls() -> [String: String] {
        return (getSettings()?.urls)!
    }
    
    func getDownloads() -> [String: URL] {
        return (getSettings()?.downloads)!
    }
    
    func getExtract() -> [String: Bool] {
        return (getSettings()?.extract)!
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

//
//  AppUpdateChecker.swift
//  NPS Browser
//
//  Created by JK3Y on 8/12/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Promises
import Alamofire

class AppUpdateChecker {
    
    func fetchLatest(successHandler: @escaping ((_ tagName: String, _ browserDownloadURL: String) -> ()) ) {
        let url = "https://api.github.com/repos/JK3Y/NPS-Browser-macOS/releases/latest"
        
        Alamofire.request(url)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let gHLatestRelease = try? newJSONDecoder().decode(GHLatestRelease.self, from: response.data!)
                    let ghVersion = gHLatestRelease?.tagName.replacingOccurrences(of: "v", with: "")
                    var browserDownloadUrl: String? = nil
                    for asset in (gHLatestRelease?.assets)! {
                        browserDownloadUrl = asset.browserDownloadURL
                    }
                    
                    successHandler(ghVersion!, browserDownloadUrl!)
                } else {
                    log.error(response.error!)
                    Helpers().makeAlert(messageText: "App Update", informativeText: "There is no new update available.", alertStyle: .informational)
                }
        }
    }
    
    func downloadUpdate(url: URL) {
        
        Helpers().showLoadingViewController()
        Helpers().getLoadingViewController().setLabel(text: "Fetching update...")
//        Helpers().getLoadingViewController().setProgress(amount: 20)
        
        let destination: DownloadRequest.DownloadFileDestination = { request, response in
            // .pkg filename
            let pathComponent = response.suggestedFilename!
            var url: URL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
            url.appendPathComponent(pathComponent)

            return (url, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to: destination)
            .downloadProgress { progress in
                Helpers().getLoadingViewController().setLabel(text: "Downloading...")
                Helpers().getLoadingViewController().setProgress(amount: progress.fractionCompleted * 100)
        }
            .responseString { response in
                response.result.ifSuccess {
                    Helpers().makeAlert(messageText: "Update Downloaded", informativeText: "Update has been downloaded.", alertStyle: .informational)
                }
                response.result.ifFailure {
                    Helpers().makeAlert(messageText: "Download failed", informativeText: "The update has failed to download.", alertStyle: .warning)
                }
                
                Helpers().getLoadingViewController().closeWindow()
        }
    }
    
}

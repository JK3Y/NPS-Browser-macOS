//
//  AppUpdateChecker.swift
//  NPS Browser
//
//  Created by JK3Y on 8/12/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Foundation
import Alamofire

class AppUpdateChecker {
    
    func makeRequest() {
        let url = "https://api.github.com/repos/JK3Y/NPS-Browser-macOS/releases/latest"
        
        Alamofire.request(url)
            .responseJSON { response in
                
                debugPrint(response)
//                let gHLatestRelease = try? newJSONDecoder().decode(GHLatestRelease.self, from: jsonData)
                
        }
        
        
    }
    
}

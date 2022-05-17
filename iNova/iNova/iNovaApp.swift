//
//  iNovaApp.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/13/22.
//

import SwiftUI

@main
struct iNovaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Since AppDelegate doesn't exist, this is how the UDID is handled.
                .onOpenURL { (url) in
                    
                    // Makes sure it contains a UDID key
                    if (url.absoluteString.contains("udid")) {
                        // Makes sure the UDID doesn't exist
                        if UserDefaults.standard.value(forKey: "udid") == nil {
                            
                            // Removes URL Scheme from UDID
                            let pureUdid = url.absoluteString.replacingOccurrences(of: "inova://?udid=", with: "")
                            
                            // Just for making sure the UDID is there
                            print("udid verified, \(pureUdid)")
                            
                            // Sets UDID
                            UserDefaults.standard.set(pureUdid, forKey: "udid")
                            UserDefaults.standard.synchronize()
                            
                        }
                    }
                    
                }
        }
    }
}

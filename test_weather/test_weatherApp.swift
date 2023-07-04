//
//  test_weatherApp.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import SwiftUI
import GoogleMobileAds

@main
struct test_weatherApp: App {
    
    init() {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

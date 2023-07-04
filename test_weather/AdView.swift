//
//  AdView.swift
//  test_weather
//
//  Created by 최유진 on 2023/06/30.
//


import SwiftUI
import GoogleMobileAds

struct AdView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            banner.rootViewController = scene.windows.first?.rootViewController
        }
        
        let request = GADRequest()
        banner.load(request)
        
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}



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
        let banner = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: 320, height: 50)))
        
        banner.adUnitID = "ca-app-pub-3042544566315852/7100925233"
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            banner.rootViewController = scene.windows.first?.rootViewController
        }

        banner.load(GADRequest())
        
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}

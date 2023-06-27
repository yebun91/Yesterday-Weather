//
//  TopBarView.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import Foundation
import SwiftUI

/**
 상단 바를 정의하는 별도의 뷰
 */
struct TopBarView: View {
    
    
    var body: some View {
        HStack {
            IconButtonView(imageName: "bars-solid")
            Spacer()
            Text("금천구")
            Spacer()
            IconButtonView(imageName: "location-dot-solid")
        }.background(Color.green)
    }
}

/**
 아이콘 버튼을 정의하는 별도의 뷰
 */
struct IconButtonView: View {
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    @State private var showSettingsAlert = false
    
    let imageName: String
    
    var body: some View {
        Button(action: {
            if locationDataManager.authorizationStatus == .authorizedWhenInUse {
                Task {
                    await weatherKitManager.getWeather(latitude: locationDataManager.latitude, longitude: locationDataManager.longitude)
                }
            } else {
                showSettingsAlert = true
            }
        }) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
        }
        .background(showSettingsAlert ? SettingsLauncher() : nil)
    }
}


struct SettingsLauncher: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // This function doesn't need to do anything for an alert.
    }
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let alert = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                // If general settings page opens (URL scheme is available in iOS 8 and later.)
                UIApplication.shared.open(url)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
        
        let viewController = UIViewController()
        viewController.view.isHidden = true
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
        
        return viewController
    }
}









//
//  TopBarView.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import Foundation
import SwiftUI
import CoreLocation

/**
 상단 바를 정의하는 별도의 뷰
 */
struct TopBarView: View {
    @State private var locationName = "Loading..."
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    var body: some View {
        HStack {
            IconButtonView(imageName: "bars-solid").opacity(0)
            Spacer()
            Text(locationName)
                .foregroundColor(Color("text"))
            Spacer()
            IconButtonView(imageName: "location-dot-solid")
        }
        .task {
            await fetchLocationName()
        }
        .onReceive(locationDataManager.$latitude.combineLatest(locationDataManager.$longitude)) { _, _ in
            Task {
                await fetchLocationName()
            }
        }
        
    }
    func fetchLocationName() async {
        let location = CLLocation(latitude: locationDataManager.latitude, longitude: locationDataManager.longitude)
        
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else {
                print("No valid placemarks found.")
                return
            }
            
            locationName = placemark.subLocality ?? "Unknown Location"
        } catch {
            print("Unable to reverse geocode the given location. Error: \(error)")
        }
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
            if imageName == "location-dot-solid" {
                if locationDataManager.authorizationStatus == .authorizedWhenInUse {
                    Task {
                        await weatherKitManager.getWeathersFromYesterdayToTomorrow(latitude: locationDataManager.latitude, longitude: locationDataManager.longitude)
                    }
                } else {
                    showSettingsAlert = false
                    showSettingsAlert = true
                }
            }
        }) {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("text"))
                .frame(width: 30, height: 30)
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

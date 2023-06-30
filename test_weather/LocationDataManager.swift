//
//  LocationDataManager.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import CoreLocation
import Foundation

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus?
    weak var weatherKitManager: WeatherKitManager?
    
    var locationManager = CLLocationManager()
    
    @Published var latitude: Double = 37.4702313
    @Published var longitude: Double = 126.8926482
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            // 권한이 부여되었을 때 위치 업데이트를 요청합니다.
            locationManager.requestLocation()
        case .restricted:
            authorizationStatus = .restricted
        case .denied:
            authorizationStatus = .denied
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            
            Task {
                await weatherKitManager?.getWeathersFromYesterdayToTomorrow(latitude: self.latitude, longitude: self.longitude)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}



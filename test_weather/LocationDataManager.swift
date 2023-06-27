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
    
    var latitude: Double {
        locationManager.location?.coordinate.latitude ?? 0.0
    }
    var longitude: Double {
        locationManager.location?.coordinate.longitude ?? 0.0
    }
    
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
            // 사용자가 위치 업데이트를 거부했을 경우 기본적으로 보여지는 위치 설정
            authorizationStatus = .denied
            let defaultLatitude = 37.5635694
            let defaultLongitude = 126.9800083
            Task {
                await weatherKitManager?.getWeather(latitude: defaultLatitude, longitude: defaultLongitude)
            }
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            Task {
                await weatherKitManager?.getWeather(latitude: latitude, longitude: longitude)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}



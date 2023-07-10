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
    
    @Published var latitude: Double = 35.118889
    @Published var longitude: Double = 126.874133
    
    // 사용자의 마지막 위치를 저장하거나 불러올 수 있는 computed property를 추가합니다.
    var lastLocation: CLLocationCoordinate2D {
        get {
            let latitude = UserDefaults.standard.double(forKey: "latitude")
            let longitude = UserDefaults.standard.double(forKey: "longitude")
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            UserDefaults.standard.set(newValue.latitude, forKey: "latitude")
            UserDefaults.standard.set(newValue.longitude, forKey: "longitude")
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        // 초기화될 때 마지막 위치를 불러옵니다.
        let location = self.lastLocation
        self.latitude = location.latitude
        self.longitude = location.longitude
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
            
            // 위치가 업데이트되면 UserDefaults에 저장합니다.
            self.lastLocation = location.coordinate
            
            Task {
                await weatherKitManager?.getWeathersFromYesterdayToTomorrow(latitude: self.latitude, longitude: self.longitude)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}



//
//  WeatherKitManager.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import WeatherKit
import CoreLocation

@MainActor class WeatherKitManager: ObservableObject {
    
    @Published var weather : Weather? {
        didSet {
            updateTemp()
        }
    }
    
    func updateTemp() {
        Task {
            self.objectWillChange.send()
        }
    }
    
    /**
     날씨 조회
     */
    func getWeather(latitude: Double, longitude: Double) async {
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                return try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            }.value
        } catch {
            fatalError("\(error)")
        }
        
    }
    
    var temp: String {
        if let temperature = weather?.currentWeather.temperature {
            let celsius = temperature.converted(to: .celsius)
            let roundedCelsius = Measurement(value: celsius.value.rounded(), unit: UnitTemperature.celsius)
            
            let formatter = MeasurementFormatter()
            formatter.numberFormatter.maximumFractionDigits = 0
            formatter.unitOptions = .providedUnit // Use the unit provided with the measurement
            
            return formatter.string(from: roundedCelsius)
        } else {
            return "Loading Weather Data"
        }
    }
}

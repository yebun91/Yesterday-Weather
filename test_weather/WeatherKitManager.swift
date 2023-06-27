//
//  WeatherKitManager.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import WeatherKit
import CoreLocation

@MainActor class WeatherKitManager: ObservableObject {
    
    @Published var nowWeather : Weather? {
        didSet {
            updateTemp()
        }
    }
    
    @Published var yesterdayWeather : Forecast<HourWeather>? {
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
    func getNowWeather(latitude: Double, longitude: Double) async {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        do {
            nowWeather = try await Task.detached(priority: .userInitiated) {
                return try await WeatherService.shared.weather(for: location)
            }.value
        } catch {
            fatalError("\(error)")
        }
        
    }
    
    func getyesterDayWeather(latitude: Double, longitude: Double) async {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        do {
            yesterdayWeather = try await Task.detached(priority: .userInitiated) {
                return try await WeatherService.shared.weather(for: location, including: .hourly(startDate: yesterday, endDate: now))
                
            }.value
            print("----------------------------")
            print(yesterdayWeather)
        } catch {
            fatalError("\(error)")
        }
    }
    
    var temp: String {
        if let temperature = nowWeather?.currentWeather.temperature {
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

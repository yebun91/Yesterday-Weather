//
//  WeatherKitManager.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import WeatherKit
import CoreLocation

@MainActor class WeatherKitManager: ObservableObject {
    
    @Published var weatherInfo : [String: HourWeather] = [:] {
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
     날씨 조회 후 딕셔너리 타입에 넣음.
     */
    func getyesterDayWeather(latitude: Double, longitude: Double) async {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: +1, to: now)!
        
        do {
            let apiData = try await Task.detached(priority: .userInitiated) {
                return try await WeatherService.shared.weather(for: location, including: .hourly(startDate: yesterday, endDate: tomorrow))
                
            }.value
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH"
            
            for hourWeather in apiData {
                let hourWeatherDateString = formatter.string(from: hourWeather.date)
                weatherInfo[hourWeatherDateString] = hourWeather
            }
            
        } catch {
            fatalError("\(error)")
        }
    }
    
    func getTemp(day: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH"
        let dayformat = formatter.string(from: day)
        if let temperature = weatherInfo[dayformat]?.temperature {
            // Convert Measurement<UnitTemperature> to String with rounding
            let roundedTemp = temperature.value.rounded()
            return String(format: "%.0f", roundedTemp)
        } else {
            return "Loading Weather Data"
        }
    }
    
    func getWeathers(day: Date) -> HourWeather? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH"
        let dayformat = formatter.string(from: day)
        if let weathers = weatherInfo[dayformat] {
            print(weathers)
            
            return weathers
        } else {
            return nil
        }
    }
}

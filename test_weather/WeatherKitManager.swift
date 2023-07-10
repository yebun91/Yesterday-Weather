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
     어제부터 내일까지의 날씨 데이터 를 api로 불러옴
     */
    func getWeathersFromYesterdayToTomorrow(latitude: Double, longitude: Double) async {
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
    
    /**
     온도 데이터만 가져옴
     */
    func getTemp(day: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH"
        let dayformat = formatter.string(from: day)
        if let temperature = weatherInfo[dayformat]?.temperature {
            let roundedTemp = temperature.value.rounded()
            return String(format: "%.0f", roundedTemp)
        } else {
            return "Loading Weather Data"
        }
    }
    
    /**
     지정한 시간의 날씨 데이터 가져옴
     */
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
    
    /**
     Date에서 현재 시간을 16:00 과 같은 형태로 가져옴
     */
    func hourString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    /**
     어제와 오늘의 온도차를 가져옴
     */
    func calculateFeelTemp(index: Int, sortedKeys: [String]) -> String {
        let yesterdayKey = Array(self.weatherInfo.keys).sorted().prefix(24)
        if index >= 0,
           let weatherToday = self.weatherInfo[sortedKeys[index]],
           let weatherYesterday = self.weatherInfo[yesterdayKey[index]] {
            let tempToday = weatherToday.temperature.value.rounded()
            let tempYesterday = weatherYesterday.temperature.value.rounded()
            let feelTemp = tempToday - tempYesterday
            // 양수일 때 "+" 기호를 붙여줍니다.
            let format = feelTemp > 0 ? "+%.0f" : "%.0f"
            return String(format: format, feelTemp)
        }
        return "0"
    }
}

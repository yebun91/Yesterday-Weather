//
//  ContentView.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var weatherKitManager = WeatherKitManager()
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            TopBarView()
            
            CurrentTempView()
            
            WeatherIndicatorView()
            
            HourlyForecastScrollView()
            
        }.padding()
            .task{
                locationDataManager.weatherKitManager = weatherKitManager // 인스턴스를 공유합니다.
                await weatherKitManager.getyesterDayWeather(latitude: locationDataManager.latitude, longitude: locationDataManager.longitude)
            }
            .environmentObject(weatherKitManager)
            .environmentObject(locationDataManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

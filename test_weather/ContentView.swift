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
            
            AdView().frame(height: 60)
            
        }.padding()
            .task{
                locationDataManager.weatherKitManager = weatherKitManager // 인스턴스를 공유합니다.
                await weatherKitManager.getWeathersFromYesterdayToTomorrow(latitude: locationDataManager.latitude, longitude: locationDataManager.longitude)
            }
            .environmentObject(weatherKitManager)
            .environmentObject(locationDataManager)
            .background(Color("backgraund"))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

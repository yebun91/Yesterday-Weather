//
//  SwiftUIView.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import Foundation
import SwiftUI

/**
 시간별 예보를 표시하는 스크롤 뷰
 */
struct HourlyForecastScrollView: View {
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    
    var body: some View {
        let weathersInfo = weatherKitManager.weatherInfo
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                let sortedKeys = Array(weathersInfo.keys).sorted().suffix(24)
                    ForEach(Array(sortedKeys.enumerated()), id: \.element) { index, hour in
                        if let weatherToday = weathersInfo[hour] {
                            // 소수점자리 반올림 한 온도로 변경
                            let temp = weatherToday.temperature.value.rounded()
                            
                            // "16:00" 형태의 시간을 얻기 위해
                            let hourOnly = weatherKitManager.hourString(from: weatherToday.date)
                            
                            // 어제와 오늘의 온도차를 가져옴
                            let feelTempString = weatherKitManager.calculateFeelTemp(index: index, sortedKeys: Array(sortedKeys))
                            
                            HourlyForecastView(hour: hourOnly, temp: "\(String(format: "%.0f", temp))°C", feelTemp: feelTempString)
                        }
                    }
            }
        }
    }
}

/**
 시간별 예보 항목을 정의하는 별도의 뷰
 */
struct HourlyForecastView: View {
    
    let hour: String
    let temp: String
    let feelTemp: String
    
    var body: some View {
        VStack{
            Spacer()
            Text(hour)
            Spacer()
            VStack{
                Text(feelTemp)
                Text(temp)
            }.frame(maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center)
            .background(Color.cyan)
        }.frame(width: 73, height: 150).background(Color.pink)
    }
}

//
//  CurrentTempView.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import Foundation
import SwiftUI
import WeatherKit

/**
 현재 온도를 표시하는 별도의 뷰
 */
struct CurrentTempView: View {
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    
    var body: some View {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let todayTemp = Int(weatherKitManager.getTemp(day: today)) ?? 0
        let yesterdayTemp = Int(weatherKitManager.getTemp(day: yesterday)) ?? 0
        let tempDifference =  todayTemp - yesterdayTemp
        
        let weather = weatherKitManager.getWeatherIconForCondition(condition: weatherKitManager.getWeathers(day: today)?.condition)
        
        Divider().frame(height: 2).background(Color("text"))
        VStack(spacing: -20){
            Image("\(weather)")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("text"))
                .frame(width: 60, height: 60)
            Text("\(tempDifference > 0 ? "+\(tempDifference)" : "\(tempDifference)")")
                .font(.system(size: 130))
                .fontWeight(.semibold)
                .foregroundColor(Color("text"))
                .frame(maxWidth: .infinity, alignment: .center)
            Text("\(todayTemp)°C")
                .foregroundColor(Color("text"))
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 25))
            
        }
        .frame(maxHeight: .infinity)
    }
    
    
    
}


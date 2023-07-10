//
//  CurrentTempView.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import Foundation
import SwiftUI

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
        
        let temp = weatherKitManager.getWeathers(day: today)
        Divider().frame(height: 2).background(Color.black)
        VStack(spacing: -25){
            Text("\(todayTemp)°C")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 25))
            Text("\(tempDifference > 0 ? "+\(tempDifference)" : "\(tempDifference)")")
                .font(.system(size: 130))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("\(temp?.symbolName ?? "")")
                .font(.system(size: 30))
                .fontWeight(.semibold)
        }
        .frame(maxHeight: .infinity)
    }
    
}

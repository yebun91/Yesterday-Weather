//
//  WeatherIndicatorView.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import Foundation
import SwiftUI

/**
 날씨 지표(바람, 습도, 강수량 등)를 표시하는 별도의 뷰
 */
struct WeatherIndicatorView: View {
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    
    var body: some View {
        let weathers = weatherKitManager.getWeathers(day: Date())
        let humidity = Int((weathers?.humidity ?? 0.0) * 100)
        let wind = weathers?.wind.speed ?? Measurement(value: 0, unit: UnitSpeed.kilometersPerHour)
        let precipitation = weathers?.precipitationAmount ?? Measurement(value: 0, unit: UnitLength.millimeters)
        
        HStack{
            WeatherIndicatorItemView(imageName: "wind-solid", text: "\(wind)")
            Spacer()
            WeatherIndicatorItemView(imageName: "droplet-solid", text: "\(humidity)%")
            Spacer()
            WeatherIndicatorItemView(imageName: "cloud-rain-solid", text: "\(precipitation)")
        }.background(Color.orange)
    }
}

/**
 날씨 지표 항목을 정의하는 별도의 뷰
 */
struct WeatherIndicatorItemView: View {
    let imageName: String
    let text: String
    
    var body: some View {
        VStack{
            Image(imageName).resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            Text(text)
        }.padding()
    }
}

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
    var body: some View {
        HStack{
            WeatherIndicatorItemView(imageName: "wind-solid", text: "0.8m/s")
            Spacer()
            WeatherIndicatorItemView(imageName: "droplet-solid", text: "59%")
            Spacer()
            WeatherIndicatorItemView(imageName: "cloud-rain-solid", text: "2.4mm")
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

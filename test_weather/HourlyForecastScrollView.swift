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
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                HourlyForecastView(hour: "17:00", temp: "13º", feelTemp: "-1")
                HourlyForecastView(hour: "18:00", temp: "13º", feelTemp: "-1")
                HourlyForecastView(hour: "19:00", temp: "13º", feelTemp: "-1")
                HourlyForecastView(hour: "20:00", temp: "14º", feelTemp: "-2")
                HourlyForecastView(hour: "21:00", temp: "14º", feelTemp: "-2")
                HourlyForecastView(hour: "22:00", temp: "15º", feelTemp: "-2")
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

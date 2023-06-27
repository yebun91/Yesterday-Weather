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
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    var body: some View {
        VStack{
            Text(weatherKitManager.temp).frame(maxWidth: .infinity, alignment: .center)
            Text("-1")
                .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
        }.frame(maxHeight: .infinity).background(Color.blue)
    }

}

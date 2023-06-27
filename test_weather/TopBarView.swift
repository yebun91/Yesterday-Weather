//
//  TopBarView.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import Foundation
import SwiftUI

/**
 상단 바를 정의하는 별도의 뷰
 */
struct TopBarView: View {
    
    
    var body: some View {
        HStack {
            IconButtonView(imageName: "bars-solid")
            Spacer()
            Text("금천구")
            Spacer()
            IconButtonView(imageName: "location-dot-solid")
        }.background(Color.green)
    }
}

/**
 아이콘 버튼을 정의하는 별도의 뷰
 */
struct IconButtonView: View {
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    let imageName: String
    
    var body: some View {
        Button(action: {
            if locationDataManager.authorizationStatus == .authorizedWhenInUse {
                Task {
                    await weatherKitManager.getWeather(latitude: locationDataManager.latitude, longitude: locationDataManager.longitude)
                }
            }else{
                print("current location data was restricted or denied.")
            }
        }) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
        }
    }
}

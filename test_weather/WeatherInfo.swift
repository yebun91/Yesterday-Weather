//
//  WeatherInfo.swift
//  test_weather
//
//  Created by rgorithm_mactest on 2023/06/27.
//

import Foundation

struct WeatherInfo: Codable {
    let response: Response
}

struct Response: Codable {
    let header: Header
    let body: Body?
}

struct Header: Codable {
    let resultCode: String
    let resultMsg: String
}

struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct Items: Codable {
    let item: [Item]
}

struct Item: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let nx: Int
    let ny: Int
    let obsrValue: String?
    let fcstDate: String?
    let fcstTime: String?
    let fcstValue: String?
}

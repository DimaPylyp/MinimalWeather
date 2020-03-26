//
//  WeatherData.swift
//  MinimalWeather
//
//  Created by DiMa on 06/03/2020.
//  Copyright © 2020 DiMa. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let city: City
    let list: [List]
}

struct City: Decodable {
    let name: String
    let sunrise: Double
    let sunset: Double
}

struct List: Decodable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let dt_txt: String
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
}

struct Weather: Decodable {
    let id: Int
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}

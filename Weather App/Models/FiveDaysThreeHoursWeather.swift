//
//  FiveDaysThreeHoursWeather.swift
//  Weather App
//
//  Created by bacho kartsivadze on 02.02.23.
//

import Foundation

struct FiveDaysThreeHoursWeather: Codable {
    let list: [List]
}

struct List: Codable {
    let main: Main
    let weather: [Weather]
    let dt_txt: String?
    
    init() {
        self.main = Main(temp: 0, humidity: 0, pressure: 0)
        self.weather = []
        self.dt_txt = ""
    }
    
    init(main: Main, weather: [Weather], dt_txt: String?) {
        self.main = main
        self.weather = weather
        self.dt_txt = dt_txt
    }
}

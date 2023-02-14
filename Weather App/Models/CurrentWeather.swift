//
//  CurrentWeather.swift
//  Weather App
//
//  Created by bacho kartsivadze on 24.01.23.
//

import Foundation

struct CurrentWeather: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let sys: System
    let name: String?
    
    
    init(coord: Coordinates, weather: [Weather], main: Main, wind: Wind, clouds: Clouds, sys: System, name: String?) {
        self.coord = coord
        self.weather = weather
        self.main = main
        self.wind = wind
        self.clouds = clouds
        self.sys = sys
        self.name = name
    }
    
    init() {
        self.coord = Coordinates(lon: nil, lat: nil)
        self.weather = [Weather(main: nil, description: nil, icon: nil)]
        self.main = Main(temp: nil, humidity: nil, pressure: nil)
        self.wind = Wind(speed: nil, deg: nil)
        self.clouds = Clouds(all: nil)
        self.sys = System(country: nil)
        self.name = "Error"
    }
}


struct Coordinates: Codable {
    let lon: Double? // actual weather
    let lat: Double?
}

struct Weather: Codable {
    let main: String? // actual weather
    let description: String?
    let icon: String?
}

struct Main: Codable {
    let temp: Double? // temperature
    let humidity: Int?
    let pressure: Int?
}

struct Wind: Codable {
    let speed: Double? // wind speed
    let deg: Int?
}


struct Clouds: Codable {
    let all: Int? // cloudiness
}

struct System: Codable {
    let country: String?
}
/**
 {
     "coord": {
         "lon": -0.1257,
         "lat": 51.5085
     },
     "weather": [
         {
             "id": 804,
             "main": "Clouds",
             "description": "overcast clouds",
             "icon": "04n"
         }
     ],
     "base": "stations",
     "main": {
         "temp": 276.02,
         "feels_like": 273.46,
         "temp_min": 273.02,
         "temp_max": 277.35,
         "pressure": 1039,
         "humidity": 88
     },
     "visibility": 10000,
     "wind": {
         "speed": 2.57,
         "deg": 60
     },
     "clouds": {
         "all": 100
     },
     "dt": 1674545347,
     "sys": {
         "type": 1,
         "id": 1414,
         "country": "GB",
         "sunrise": 1674546627,
         "sunset": 1674578053
     },
     "timezone": 0,
     "id": 2643743,
     "name": "London",
     "cod": 200
 }
 */

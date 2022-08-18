//
//  WeatherData.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 16/8/2565 BE.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let weather: [Weather]
    let coord: Coord
    let main: Main
    let wind: Wind
    let clouds: Clouds
}

struct Weather: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Coord: Codable{
    let lon: Float
    let lat: Float
}

struct Main: Codable{
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max:Float
    let humidity: Int
    //    let pressure: Int
}
struct Wind: Codable{
    let speed: Float
    let deg: Float
}

struct Clouds: Codable{
    let all: Int
}

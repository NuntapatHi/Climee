//
//  WeatherForcastData.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 20/12/2565 BE.
//

import Foundation

struct WeatherForcastData: Codable{
    let list: [ListForcast]
}

struct ListForcast: Codable{
    let main: Main
    let weather: [Weather]
    let dt_txt: String
    let clouds: Clouds
}

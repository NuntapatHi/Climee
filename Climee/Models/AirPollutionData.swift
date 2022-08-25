//
//  AirPollution.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 23/8/2565 BE.
//

import Foundation

struct AirPollutionData: Codable{
    let list: [List]
}

struct List: Codable{
    let main: AQI
    let components: Components
}
struct AQI: Codable{
    let aqi: Int
}

struct Components: Codable{
    let co: Float
    let no: Float
    let no2: Float
    let o3: Float
    let so2: Float
    let pm2_5: Float
    let pm10: Float
    let nh3: Float
}

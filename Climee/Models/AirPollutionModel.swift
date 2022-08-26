//
//  AirPollutionModel.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 23/8/2565 BE.
//

import Foundation
struct AirPollutionModel{
    let airPollutionData: AirPollutionData
    
    var statusAQI: [String]{
        switch airPollutionData.list[0].main.aqi{
        case 1:
            return ["very-good-emotion" ,"Very Good", "All activities as normal", "aqi-index-1"]
        case 2:
            return ["good-emotion" ,"Good", "Moderate outside activities for sensitive groups", "aqi-index-2"]
        case 3:
            return ["moderate-emotion" ,"moderate", "Limit outside activities for sensitive groups", "aqi-index-3"]
        case 4:
            return ["poor-emotion" ,"Poor", "Stay indoors, no outside activities", "aqi-index-4"]
        case 5:
            return ["very-poor-emotion" ,"Very Poor", "All outdoor activities cancelled and consult Ministry of Education directive", "aqi-index-5"]
        default:
            return ["very-poor-emotion" ,"No status AQI", "Something go wrong", "aqi-index-5"]
        }
    }
}

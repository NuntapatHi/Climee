//
//  WeatherModel.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 16/8/2565 BE.
//

import Foundation

struct WeatherModel{
    let weatherData: WeatherData
    
    var windDirection: String{
        switch weatherData.wind.deg{
        case 0...22.4:
            return "North"
        case 22.5...44.9:
            return "North-Northeast"
        case 45...67.4:
            return "Northeast"
        case 67.5...89.9:
            return "East-Northeast"
        case 90...112.4:
            return "East-Southeast"
        case 112.5...134.9:
            return "East-Southeast"
        case 135...157.4:
            return "Southeast"
        case 157.5...179.9:
            return "South-Southeast"
        case 180...202.4:
            return "South"
        case 202.5...224.9:
            return "South-Southwest"
        case 225...247.4:
            return "Southwest"
        case 247.5...269.9:
            return "West-Southwest"
        case 270...292.4:
            return "West"
        case 292.5...314.9:
            return "West-Northwest"
        case 315...337.4:
            return "Northwest"
        case 337.5...359.9:
            return "North-Northwest"
        default:
            return "No wind direction."
        }
    }
    
    var imgUrlString: String{
        get{
            let urlString = "\(K.weatherImgURL)\(weatherData.weather[0].icon)@2x.png"
            return urlString
        }
    }
    
    var visibilityDistance: Float{
        get{
            let distance = Float((weatherData.visibility)/1000)
            return distance
        }
    }
}

//
//  WeatherManager.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 16/8/2565 BE.
//

import Foundation
import UIKit
protocol WeatherManagerDelegate{
    func weatherDidUpdate(_ weatherManager: WeatherManager, weatherData: WeatherData)
    func weatherWithError(_ weatherManager: WeatherManager, error: Error)
}

struct WeatherManager{
    
    var delegate: WeatherManagerDelegate?
    
    let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&"
    
    let openWeatherImgURL = "http://openweathermap.org/img/wn/"
    
    let apikey = "addac5760d2063966c0f5102171286c7"
    
    func weatherFatch(cityName: String){
        var urlString = "\(openWeatherURL)appid=\(apikey)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.weatherWithError(self, error: error!)
                    return
                }
                if let safeData = data{
                    parseJSON(safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            delegate?.weatherDidUpdate(self, weatherData: decodedData)
        } catch{
            delegate?.weatherWithError(self, error: error)
        }
    }
}
